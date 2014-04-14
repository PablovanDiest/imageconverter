class ConverterController < ApplicationController
  require 'RMagick'
  include Magick
  respond_to :html, :json, :text

  def index

  end

  def upload
    uploaded_file = params[:file]
    #Create the needed folders
    Dir.mkdir(Rails.root.join('public','uploads')) unless Dir.exist?(Rails.root.join('public','uploads'))
    Dir.mkdir(Rails.root.join('public','uploads', request.remote_ip)) unless Dir.exist?(Rails.root.join('public','uploads', request.remote_ip))
    #Open the file and write it
    File.open(Rails.root.join('public','uploads', request.remote_ip, uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    redirect_to uploaded_converter_path(uploaded_file.original_filename.gsub('.','^'))
  end

  def uploaded
    @converted_file_name = Rails.root.join('public', 'uploads', request.remote_ip, params[:id].gsub('^', '.'))
    respond_with()
  end

  def convert
    from_format = params[:from_format]
    to_format = params[:to_format]
    path_name = Rails.root.join('public', 'uploads', request.remote_ip).to_s
    #Scan every file in the folder with the selected format, and convert it
    Dir.glob("#{path_name}/*#{from_format}").each do |uploaded_file|
      convert_file(uploaded_file, from_format, to_format)
      File.delete(uploaded_file)
    end
    redirect_to download_converter_index_path(:to_format => to_format)
  end

  def download
    @folder_name = Rails.root.join('public', 'uploads', request.remote_ip)
    @folder_rest = Rails.root.join('public')
    @to_format   = params[:to_format]
    respond_with()
  end

  private
  #Convert the image file from a format to another
  def convert_file(file_name, from_format, to_format)
    begin
      from_file_name = Rails.root.join('public', 'uploads', request.remote_ip, file_name)
      to_file_name   = Rails.root.join('public', 'uploads', request.remote_ip, file_name.gsub(from_format, to_format))
      #Read the uploaded image from the disk
      from_image = Image.read(from_file_name).first
      #Copy the image into a new variable
      to_image = from_image.copy
      #Change the format for the selected by user
      to_image.format = to_format[1..3].upcase
      #Write the copied image with the new format into the user temporal folder
      to_image.write(to_file_name)
    rescue Exception => e
      raise
    end
  end
end