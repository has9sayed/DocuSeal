class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :send_for_signature, :preview]

  def index
    @documents = current_user.documents.order(created_at: :desc)
  end

  def show
  end

  def new
    @document = if params[:template_id]
      template = Template.find(params[:template_id])
      template.create_document
    else
      current_user.documents.new
    end
  end

  def create
    @document = current_user.documents.new(document_params)

    if @document.save
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      redirect_to @document, notice: 'Document was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_url, notice: 'Document was successfully deleted.'
  end

  def send_for_signature
    if @document.send_for_signature
      redirect_to @document, notice: 'Document has been sent for signature.'
    else
      redirect_to @document, alert: 'Failed to send document for signature.'
    end
  end

  def preview
    respond_to do |format|
      format.html
      format.pdf do
        pdf_service = PdfGeneratorService.new(@document)
        if pdf_service.generate
          send_data @document.pdf_file.download,
                   filename: "#{@document.title}_preview.pdf",
                   type: 'application/pdf',
                   disposition: 'inline'
        else
          redirect_to @document, alert: 'Failed to generate preview'
        end
      end
    end
  end

  private

  def set_document
    @document = current_user.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :description, :template_id, :pdf_file)
  end
end 