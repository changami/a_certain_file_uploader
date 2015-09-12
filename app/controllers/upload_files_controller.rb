class UploadFilesController < ApplicationController
  before_action :set_upload_file, only: [:show, :destroy]

  # GET /upload_files
  # GET /upload_files.json
  def index
    @upload_files = UploadFile.all
  end

  # GET /upload_files/1
  # GET /upload_files/1.json
  def show
    if @upload_file.present?
      dl_filename = @upload_file.filename
      dl_filename = ERB::Util.url_encode(dl_filename) if isIE?
      send_file upload_filepath, filename: dl_filename
    else
      redirect_to upload_files_url
    end
  end

  # GET /upload_files/new
  def new
    @upload_file = UploadFile.new
  end

  # POST /upload_files
  # POST /upload_files.json
  def create
    form_params = upload_file_params

    # check space quota
    if form_params[:file].size + current_user.space_usage > current_user.space_quota
      flash[:alert] = 'File could not be uploaded because space limit exceed.'
      redirect_to action: :new
      return
    end

    @upload_file = UploadFile.new(user: current_user,
                                  filename: form_params[:file].original_filename,
                                  description: form_params[:description])
    if @upload_file.save
      begin
        if FileTest.exist?(File.dirname(upload_filepath)) == false
          FileUtils.mkdir_p(File.dirname(upload_filepath))
        end
        File.open(upload_filepath, 'wb') do |f|
          f.flock(File::LOCK_EX)
          f.write(form_params[:file].read)
          f.flush
        end
      rescue
        flash[:alert] = 'File could not be uploaded due to technical reasons.'
        redirect_to action: :new
      else
        OperationHistory.create(user: current_user,
                                operation: OperationHistory.operations[:upload],
                                filename: @upload_file.filename,
                                upload_file: @upload_file)
        flash[:notice] = 'File was successfully uploaded.'
        redirect_to upload_files_url
      end
    else
      flash[:alert] = 'File could not be uploaded due to technical reasons.'
      redirect_to action: :new
    end
  end

  # DELETE /upload_files/1
  # DELETE /upload_files/1.json
  def destroy
    if @upload_file.present?
      if @upload_file.user == current_user
        filepath = upload_filepath
        if FileTest.exist?(filepath)
          begin
            File.delete filepath
          rescue
            redirect_to upload_files_url, notice: 'File could not be removed due to technical reasons.'
          else
            OperationHistory.create(user: current_user,
                                    operation: OperationHistory.operations[:remove],
                                    filename: @upload_file.filename,
                                    upload_file: nil)
            @upload_file.destroy
            redirect_to upload_files_url, notice: 'File was successfully removed.'
          end
        else
          @upload_file.destroy
          redirect_to upload_files_url
        end
      else
        redirect_to upload_files_url, notice: 'You can not remove file. Need logged in as file\'s owner.'
      end
    else
      redirect_to upload_files_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload_file
      @upload_file = UploadFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_file_params
      params.require(:upload_file).permit(:file, :description)
    end

    def isIE?
      request.user_agent =~ /MSIE/ || request.user_agent =~ /Trident/
    end

    def upload_filepath
      File.join(ACertainFileUploader::Application.config.upload_dir, @upload_file.uuid)
    end
end
