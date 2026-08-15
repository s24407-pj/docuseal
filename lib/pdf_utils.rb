# frozen_string_literal: true

module PdfUtils
  DEFAULT_DPI = 72
  US_LETTER_W = DEFAULT_DPI * 8.5

  module_function

  def encrypted?(data, password: nil)
    HexaPDF::Document.new(io: StringIO.new(data), decryption_opts: { password: })

    false
  rescue HexaPDF::EncryptionError
    true
  end

  def decrypt(data, password)
    decrypted_io = StringIO.new

    Pdfium::Document.open_bytes(data, password) do |doc|
      doc.save(decrypted_io, flags: Pdfium::FPDF_REMOVE_SECURITY)
    end

    decrypted_io.tap(&:rewind).read
  end

  def merge(files)
    merged_pdf = HexaPDF::Document.new

    files.each do |file|
      pdf = HexaPDF::Document.new(io: file)
      pdf.pages.each { |page| merged_pdf.pages << merged_pdf.import(page) }
    end

    merged_content = StringIO.new
    merged_pdf.validate(auto_correct: true)
    merged_pdf.write(merged_content, validate: false)
    merged_content.rewind

    merged_content
  end
end
