require 'aws-sdk'

    class PdfService
        def call
            textract = Aws::Textract::Client.new(
                access_key_id: Rails.application.credentials.aws.access_key_id,
                secret_access_key: Rails.application.credentials.aws.secret_access_key,
                region: Rails.application.credentials.aws.region
            )
        
            request = textract.start_document_analysis({
                document_location: {
                s3_object: {
                    bucket: "textract-console-us-east-1-0459c275-2f15-41a9-a029-cc1683be8bd9", #S3 Bucket name
                    name: "03a2860b_4f92_4112_a962_457a53bed3b4_kenco_order.pdf", #S3 Object name
                },
            },
            feature_types: ["TABLES"],
            })
            
            resp = textract.get_document_analysis({
                job_id: request.job_id,
            })

            while resp.job_status != "SUCCEEDED"
                resp = textract.get_document_analysis({
                job_id: request.job_id,
            })
                puts resp.job_status
                sleep(2)
            end

            if resp.job_status == "SUCCEEDED"
                puts resp.blocks[25].text
            end
        end
    end