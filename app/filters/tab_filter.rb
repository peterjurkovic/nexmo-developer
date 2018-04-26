class TabFilter < Banzai::Filter
  def call(input)
    input.gsub(/^(\s*)```tabbed_(examples|content)(.+?)```/m) do |_s|
      @indentation = $1
      @mode = $2
      @config = YAML.safe_load($3)
      validate_config
      html
    end
  end

  private

  def create_tabs(content)
    tab = Nokogiri::XML::Element.new 'li', @document
    tab['class'] = 'tabs-title'
    tab['class'] += ' is-active' if content[:active]

    if content[:language]
      tab['data-language'] = content[:language].key
      tab['data-language-type'] = content[:language].type
      tab['data-language-linkable'] = content[:language].linkable?
    end

    if content[:platform]
      tab['data-language'] = content[:platform].languages.map(&:key).join(',')
      tab['data-platform'] = content[:platform].key
      tab['data-platform-type'] = content[:platform].type
      tab['data-platform-linkable'] = content[:platform].linkable?
    end

    tab_link = Nokogiri::XML::Element.new 'a', @document
    tab_link.content = content[:tab_title]
    tab_link['href'] = "##{content[:id]}"

    tab.add_child(tab_link)
    @tabs.add_child(tab)
  end

  def create_content(content)
    element = Nokogiri::XML::Element.new 'div', @document
    element['id'] = content[:id]
    element['class'] = 'tabs-panel'
    element['class'] += ' is-active' if content[:active]
    element.inner_html = content[:body]

    @tabs_content.add_child(element)
  end

  def is_tabbed_code_examples?
    @mode == 'examples'
  end

  def is_tabbed_content?
    @mode == 'content'
  end

  def html
    id = SecureRandom.hex

    html = <<~HEREDOC
      <div>
        <ul class="tabs" data-tabs id="#{id}"></ul>
        <div class="tabs-content" data-tabs-content="#{id}"></div>
      </div>
    HEREDOC

    @document = Nokogiri::HTML::DocumentFragment.parse(html)
    @tabs = @document.at_css('.tabs')
    @tabs_content = @document.at_css('.tabs-content')

    if is_tabbed_code_examples?
      @tabs['class'] += ' tabs--code'
      @tabs_content['class'] += ' tabs-content--code'
    end

    if @config['frameless']
      @tabs['class'] += ' tabs--frameless'
      @tabs_content['class'] += ' tabs-content--frameless'
    end

    contents.each do |content|
      create_tabs(content)
      create_content(content)
    end

    source = @document.to_html

    "#{@indentation}FREEZESTART#{Base64.urlsafe_encode64(source)}FREEZEEND"
  end

  def contents
    list = content_from_source if @config['source']
    list = content_from_tabs if @config['tabs']
    list = content_from_config if @config['config']

    list ||= []

    return list unless list.any?

    list = resolve_language(list)

    if is_tabbed_code_examples?
      list = format_code(list)
      list = resolve_code(list)
      list = resolve_tab_title(list)
    end

    list = sort_contents(list)
    resolve_active_tab(list)

    list
  end

  def validate_config
    return if @config && (@config['source'] || @config['tabs'] || @config['config'])
    raise 'A source, tabs or config key must be present in this tabbed_example config'
  end

  def content_from_source
    source_path = "#{Rails.root}/#{@config['source']}"
    source_path += '/*' if is_tabbed_code_examples?
    source_path += '/*.md' if is_tabbed_content?

    Dir[source_path].map do |content_path|
      source = File.read(content_path)

      content = {
        :id => SecureRandom.hex,
        :source => source,
      }

      if is_tabbed_code_examples?
        language_key = File.basename(content_path, ".*").downcase
        content[:language_key] = language_key
      end

      if is_tabbed_content?
        content[:frontmatter] = YAML.safe_load(source)
        content[:language_key] = content[:frontmatter]['language']
        content[:platform_key] = content[:frontmatter]['platform']
        content[:tab_title] = content[:frontmatter]['title']
        content[:body] = MarkdownPipeline.new(options).call(source)
      end

      content
    end
  end

  def content_from_tabs
    @config['tabs'].map do |title, config|
      source = File.read(config['source'])

      config.symbolize_keys.merge({
        :id => SecureRandom.hex,
        :source => source,
        :language_key => title.dup.downcase
      })
    end
  end

  def content_from_config
    configs = YAML.load_file("#{Rails.root}/config/code_examples.yml")

    begin
      config = @config['config'].split('.').inject(configs) { |h, k| h[k] }
    rescue NoMethodError
      raise "Example missing (#{@config['config']}) in code_examples.yml. Try restarting the server or check for presence of key."
    end

    config.map do |title, config|
      source = File.read(config['source'])

      config.symbolize_keys.merge({
        :id => SecureRandom.hex,
        :source => source,
        :language_key => title.dup.downcase
      })
    end
  end

  def resolve_language(contents)
    contents.map do |content|
      if content[:language_key]
        content.merge!({
          :language => CodeLanguageResolver.find(content[:language_key]),
        })
      end

      if content[:platform_key]
        content.merge!({
          :platform => CodeLanguageResolver.find(content[:platform_key]),
        })
      end

      content
    end
  end

  def format_code(contents)
    contents.each do |content|
      if content[:from_line] || content[:to_line]
        lines = content[:source].lines
        total_lines = lines.count
        from_line = (content[:from_line] || 1) - 1
        to_line = (content[:to_line] || total_lines) - 1
        content[:source] = lines[from_line..to_line].join
      end

      content[:source].unindent! if content[:unindent]
    end
  end

  def resolve_code(contents)
    contents.map do |content|
      @formatter ||= Rouge::Formatters::HTML.new
      lexer = content[:language].lexer
      highlighted_source = @formatter.format(lexer.lex(content[:source]))
      body = <<~HEREDOC
        <pre class="highlight #{content[:language_key]}"><code>#{highlighted_source}</code></pre>
      HEREDOC

      content.merge!({ :body => body })
    end
  end

  def resolve_tab_title(contents)
    contents.map do |content|
      content.merge!({ :tab_title => content[:language].label })
    end
  end

  def sort_contents(contents)
    contents.sort_by do |content|
      next content[:language].weight if content[:language]
      next content[:frontmatter]['menu_weight'] || 999 if content[:frontmatter]
      999
    end
  end

  def resolve_active_tab(contents)
    active_index = nil

    if options[:code_language]
      contents.each_with_index do |content, index|
        %i{language_key platform_key}.each do |key|
          active_index = index if content[key] == options[:code_language].key
        end
      end
    end

    @tabs['data-has-initial-tab'] = active_index.present?
    active_index ||= 0

    contents[active_index][:active] = true
  end
end
