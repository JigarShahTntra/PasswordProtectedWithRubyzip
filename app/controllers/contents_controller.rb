require 'rubygems'
require 'zip'

class ContentsController < ApplicationController
  include ContentsHelper

  def new
  end

  def index
  	@content = Content.all
  end

  def create
    if params[:files].present?
      get_variables_for_zip(params)
      buffer = Zip::OutputStream.write_buffer(::StringIO.new(''), Zip::TraditionalEncrypter.new(@password)) do |out|
                @input_filenames.each do |filename|
                  out.put_next_entry(filename)
                  out.write File.open("#{@folder}/#{filename}").read
                end
               end

       File.open(@zipfile_name, 'wb') {|f| f.write(buffer.string) }
       redirect_to root_path
    end
  end

  private

  def get_variables_for_zip(params)
    @input_filenames = []
    params[:files].select {|f| @input_filenames << f.path.gsub('/tmp/', '') }
    @folder = "/tmp/"
    @zipfile_name = "#{Dir.pwd}/download/#{params[:out_name]}.zip"
    @password = params[:password]
  end
end
