class PagesController < ApplicationController
  include FeatureFlags
  skip_authorization_check

  feature_flag :help_page, if: lambda { params[:id] == "help/index" }

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    if @custom_page.present?
      @cards = @custom_page.cards
      render action: :custom_page
    else
      render action: params[:id]
    end
  rescue ActionView::MissingTemplate
    head :not_found, content_type: "text/html"
  end

  def send_contact_form
    author = params['author']
    author_email = params['author_email']
    author_phone = params['author_phone']
    body = params['body']
    Mailer.contact_form(body, author, author_email, author_phone, 'contacto@ugu.cl').deliver_later
    flash[:notice] = "Formulario de contacto enviado."
    redirect_to help_path
  end
end
