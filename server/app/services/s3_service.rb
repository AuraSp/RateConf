require 'aws-sdk'

class S3Service
    def object_uploaded?(s3, bucket_name, object_key)
        response = s3.bucket(bucket_name).object(object_key).upload_file('app/services/test1.pdf')
    
    end

    def run()
        #creating aws client for S3 service
        s3 = Aws::S3::Resource.new(
                access_key_id: Rails.application.credentials.aws.access_key_id,
                secret_access_key: Rails.application.credentials.aws.secret_access_key,
                region: Rails.application.credentials.aws.region
            )
        bucket_name = 'team3-pdfers-rateconfocr-bucket'
        object_key = 'test1.pdf'

        if object_uploaded?(s3, bucket_name, object_key)
            puts "Object '#{object_key}' uploaded to bucket - '#{bucket_name}'."
        else
            puts "Object '#{object_key}' not uploaded to bucket - '#{bucket_name}'."
        end
    end

end