class SearchTerms
  def self.generate
    document_paths = {
      documentation: {
        documents: Dir.glob("#{Rails.root}/_documentation/**/*.md"),
        origin: Pathname.new("#{Rails.root}/_documentation"),
        base_url_path: '',
      },
      api: {
        documents: Dir.glob("#{Rails.root}/_api/**/*.md"),
        origin: Pathname.new("#{Rails.root}/_api"),
        base_url_path: '/api',
      },
      tutorials: {
        documents: Dir.glob("#{Rails.root}/_tutorials/**/*.md"),
        origin: Pathname.new("#{Rails.root}/_tutorials"),
        base_url_path: '/tutorials',
      },
    }

    (document_paths.map do |document_class, config|
      config[:documents].map do |document_path|
        document = File.read(document_path)
        frontmatter = YAML.safe_load(document)
        title = frontmatter['title']
        description = frontmatter['description']

        puts document_path

        body_html = MarkdownPipeline.new.call(document)

        Nokogiri::HTML(body_html).split_html.map do |section_html|
          body = section_html.text

          document_path = Pathname.new(document_path)
          relative_path = "#{config[:base_url_path]}/#{document_path.relative_path_from(config[:origin])}".gsub('.md', '')

          product = relative_path.split('/')[1]

          if product == 'messaging'
            product = "#{relative_path.split('/')[1]} > #{relative_path.split('/')[2]}"
          end

          {
            title: title,
            heading: section_html.css('body').children[0].text.strip,
            anchor: section_html.css('body').children[0].text.parameterize,
            description: description,
            document_class: document_class,
            path: relative_path,
            document_path: document_path,
            body: body,
            product: product,
          }
        end
      end
    end
    ).flatten
  end
end
