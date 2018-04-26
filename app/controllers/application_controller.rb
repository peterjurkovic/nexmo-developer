class ApplicationController < ActionController::Base
  rescue_from Errno::ENOENT, with: :no_document
  rescue_from Errno::ENOENT, with: :no_document
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], if: :requires_authentication?

  force_ssl if: :ssl_configured?
  before_action :set_show_feedback
  before_action :set_notices
  before_action :set_code_language
  before_action :set_feedback_author

  def not_found
    redirect = Redirector.find(request)
    if redirect
      redirect_to redirect
    else
      NotFoundNotifier.notify(request)
      render 'static/404', status: :not_found, formats: [:html]
    end
  end

  def authenticate_admin!
    return redirect_to new_user_session_path unless user_signed_in?
    redirect_to root_path unless current_user.admin?
  end

  private

  def requires_authentication?
    ENV['USERNAME'] && ENV['PASSWORD']
  end

  def no_document
    not_found
  end

  def set_show_feedback
    @show_feedback = true
  end

  def set_code_language
    return unless request.params[:code_language]
    @code_language = CodeLanguageResolver.find(request.params[:code_language])
  end

  def ssl_configured?
    return false if ENV['DISABLE_SSL']
    return false if Rails.env.development?
    return false if Rails.env.test?
    true
  end

  def set_notices
    @notices ||= YAML.load_file("#{Rails.root}/config/notices.yml")
  end

  def set_feedback_author
    return unless cookies[:feedback_author_id]
    @feedback_author = Feedback::Author.select(:email).find_by_id(cookies[:feedback_author_id])
  end
end
