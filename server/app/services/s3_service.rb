require "aws-sdk"

class S3Service
  def object_uploaded?(s3, bucket_name, object_key, path)
    response = s3.bucket(bucket_name).object(object_key).upload_file(path) #file location
  rescue
    false
  end

  def run()
    #creating aws client for S3 service
    s3 = Aws::S3::Resource.new(
      access_key_id: Rails.application.credentials.aws.access_key_id,
      secret_access_key: Rails.application.credentials.aws.secret_access_key,
      region: Rails.application.credentials.aws.region,
    )

    path = "app/services/test1.pdf"

    bucket_name = "team3-pdfers-rateconfocr-bucket" #always remains the same
    object_key = File.basename(path) #how to name the file

    if object_uploaded?(s3, bucket_name, object_key, path)
      puts "Object '#{object_key}' uploaded to bucket - '#{bucket_name}'."
      newAudit = Audit.create(:File_id => params[:company], :Process_status => true)
    else
      puts "Object '#{object_key}' not uploaded to bucket - '#{bucket_name}'."
      newAudit = Audit.create(:File_id => params[:company], :Process_status => true)
    end
  end
end
