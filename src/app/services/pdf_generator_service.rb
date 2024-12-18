class PdfGeneratorService
  def initialize(document)
    @document = document
    @template = document.template
  end

  def generate
    return false unless @document.pdf_file.attached? || (@template && @template.template_file.attached?)

    pdf = if @template&.template_file&.attached?
      CombinePDF.load(@template.template_file.download)
    else
      CombinePDF.load(@document.pdf_file.download)
    end

    # Add form fields to the PDF
    @document.form_fields.each do |field|
      add_field_to_pdf(pdf, field)
    end

    # Generate temporary file
    temp_pdf = Tempfile.new(['document', '.pdf'])
    pdf.save(temp_pdf.path)

    # Attach the generated PDF to the document
    @document.pdf_file.attach(
      io: File.open(temp_pdf.path),
      filename: "#{@document.title.parameterize}.pdf",
      content_type: 'application/pdf'
    )

    temp_pdf.close
    temp_pdf.unlink

    true
  rescue StandardError => e
    Rails.logger.error "PDF generation failed: #{e.message}"
    false
  end

  private

  def add_field_to_pdf(pdf, field)
    page = pdf.pages[0] # Currently only supporting single page documents

    case field.field_type.to_sym
    when :text
      add_text_field(page, field)
    when :signature
      add_signature_field(page, field)
    when :date
      add_date_field(page, field)
    when :checkbox
      add_checkbox_field(page, field)
    end
  end

  def add_text_field(page, field)
    page.textbox(
      field.value || "[#{field.label}]",
      x: field.position_x,
      y: field.position_y,
      width: field.width || 100,
      height: field.height || 20
    )
  end

  def add_signature_field(page, field)
    if field.value.present? && field.signature_image.attached?
      # Add the signature image
      image_data = field.signature_image.download
      page.image(
        image_data,
        x: field.position_x,
        y: field.position_y,
        width: field.width || 150,
        height: field.height || 50
      )
    else
      # Add a placeholder
      page.textbox(
        "[Signature Required]",
        x: field.position_x,
        y: field.position_y,
        width: field.width || 150,
        height: field.height || 50,
        style: :italic
      )
    end
  end

  def add_date_field(page, field)
    value = field.value.present? ? Time.zone.parse(field.value).strftime('%B %d, %Y') : "[Date]"
    page.textbox(
      value,
      x: field.position_x,
      y: field.position_y,
      width: field.width || 100,
      height: field.height || 20
    )
  end

  def add_checkbox_field(page, field)
    checked = field.value == '1' || field.value == 'true'
    mark = checked ? '☒' : '☐'
    page.textbox(
      mark,
      x: field.position_x,
      y: field.position_y,
      width: field.width || 20,
      height: field.height || 20
    )
  end
end 