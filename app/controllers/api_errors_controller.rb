class ApiErrorsController < ApplicationController
  before_action :set_error_config

  def index
    @errors_title = 'Generic Errors'
    @errors = generic_errors
    @scoped_errors = @error_config['products'].map do |key, config|
      {
        key: key,
        config: config,
        errors: scoped_errors(key)
      }
    end
  end

  def index_scoped
    @errors_title = @error_config['products'][params[:definition]]['title']
    @errors = scoped_errors(params[:definition])
    render 'index'
  end

  def show
    if params[:definition]
      @error = scoped_error(params[:definition], params[:id])
    else
      @error = ApiError.new(@error_config['generic_errors'][params[:id]])
    end
  end

  private

  def generic_errors
    errors = @error_config
    ApiError.parse_config(errors['generic_errors'])
  end

  def scoped_errors(definition)
    definition = OpenApiDefinitionResolver.find(definition)
    errors = definition.raw['x-errors']
    ApiError.parse_config(errors)
  end

  def scoped_error(definition, id)
    definition = OpenApiDefinitionResolver.find(definition)
    error = definition.raw['x-errors'][id]
    ApiError.new(error)
  end

  def set_error_config
    @error_config ||= YAML.load_file("#{Rails.root}/config/api-errors.yml")
  end
end
