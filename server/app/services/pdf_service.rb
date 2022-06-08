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
            feature_types: ["TABLES", "FORMS"],
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

                extractedKey = ""
                prevExtractedKey = ""
                extractedValue = ""

                keyValueHash = Hash.new( "pair" )

                for index in (0...resp.blocks.length)
            
                    if resp.blocks[index].block_type == "KEY_VALUE_SET"

                        if resp.blocks[index].relationships.nil? == false

                            for x in (0...resp.blocks[index].relationships.length)

                                if resp.blocks[index].entity_types[0] == "KEY"
                                    if resp.blocks[index].relationships[x].type == "CHILD"
                            
                                        extractedKey = ""

                                        for a in (0...resp.blocks[index].relationships[x].ids.length)
                                            extrId = resp.blocks[index].relationships[x].ids[a]
                                            extractedKey += resp.blocks.find{|b| b.id == extrId}.text
                                            extractedKey += " " 

                                        end

                                    end

                                end

                                if resp.blocks[index].entity_types[0] == "VALUE"
                            
                                    if resp.blocks[index].relationships[x].type == "CHILD"
                                
                                        extractedValue = ""

                                        for a in (0...resp.blocks[index].relationships[x].ids.length)
                                            extrId = resp.blocks[index].relationships[x].ids[a]
                                            extractedValue += resp.blocks.find{|b| b.id == extrId}.text
                                            extractedValue += " "
                                        end

                                    end

                                end

                            end

                        end

                        if(extractedKey != "")
                            #puts "\nKEY: "
                            #puts extractedKey
                            prevExtractedKey = extractedKey
                            extractedKey = ""
                        end

                        if(extractedValue != "")
                            #puts "VALUE: "
                            #puts extractedValue
                    
                            keyValueHash.store(prevExtractedKey, extractedValue)

                            prevExtractedKey = ""
                            extractedValue = ""
                        end

                    end

                end
            
                puts keyValueHash

            end

        end
    end

