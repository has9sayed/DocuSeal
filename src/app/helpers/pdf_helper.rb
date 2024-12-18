module PdfHelper
  def pdf_preview(pdf_file)
    return unless pdf_file.attached?

    content_tag :div, class: 'pdf-preview' do
      if pdf_file.content_type == 'application/pdf'
        content_tag :iframe, nil,
          src: rails_blob_path(pdf_file, disposition: 'inline'),
          width: '100%',
          height: '100%',
          frameborder: '0',
          allowfullscreen: true
      else
        content_tag :div, class: 'alert alert-warning' do
          'Invalid file format. Please upload a PDF file.'
        end
      end
    end
  end
end 