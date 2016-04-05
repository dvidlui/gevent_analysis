Paperclip.interpolates :custom_filename do |attachment, style|
  # Generate your desired file name here.
  # The values returned should be able to be regenerated in the future because
  # this will also be called to get the attachment path.

  # For example, you can use a digest of the file name and updated_at field.
  # File name and updated_at will remain the same as long as the file is not 
  # changed, so this is a safe choice.
  attachment.original_filename
end