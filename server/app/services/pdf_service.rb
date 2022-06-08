require "aws-sdk"

class PdfService
  PdfField = Struct.new(:value, :x, :y, :width, :height)

  def call(company)

    #Company parameter
    #kenco/rjw
    company = "kenco"

    textract = Aws::Textract::Client.new(
      access_key_id: Rails.application.credentials.aws.access_key_id,
      secret_access_key: Rails.application.credentials.aws.secret_access_key,
      region: Rails.application.credentials.aws.region,
    )

    request = textract.start_document_analysis({
      document_location: {
        s3_object: {
          bucket: "textract-console-us-east-1-0459c275-2f15-41a9-a029-cc1683be8bd9", #S3 Bucket name
          name: "03a2860b_4f92_4112_a962_457a53bed3b4_kenco_order.pdf", #S3 Object name
        },
      },
      feature_types: ["FORMS", "TABLES"],
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
      case company
      when "kenco"
        extractData_kenco(resp.blocks)
      when "rjw"
        extractData_rjw(resp.blocks)
      end
    end
  end

  #Main functions

  #extract function returning key value pairs
  def extractKeyValuePairs(awsBlocks)
    extractedKey = ""
    prevExtractedKey = ""
    extractedValue = ""

    keyValueHash = Hash.new("pair")

    awsBlocks.each do |block|
      if block.block_type == "KEY_VALUE_SET"
        if block.relationships.nil? == false
          block.relationships.each do |relationship|
            extractedKey = extractFromEntityTypeAndRelation(awsBlocks, block, relationship, "KEY", "CHILD")
            extractedValue = extractFromEntityTypeAndRelation(awsBlocks, block, relationship, "VALUE", "CHILD")
          end
        end

        if (extractedKey != "")
          prevExtractedKey = extractedKey
          extractedKey = ""
        end

        if (extractedValue != "")
          keyValueHash.store(
            prevExtractedKey, extractedValue
          )
          #PdfField.new(extractedValue,
          #    resp.blocks[index].geometry.bounding_box.left,
          #   resp.blocks[index].geometry.bounding_box.top,
          #    resp.blocks[index].geometry.bounding_box.width,
          #    resp.blocks[index].geometry.bounding_box.height)
          #)

          prevExtractedKey = ""
          extractedValue = ""
        end
      end
    end

    return keyValueHash
  end

  #extract function returning tables
  #very shit currently
  def extractKeyTableData(awsBlocks)
    for index in (0...awsBlocks.length)
      if (awsBlocks[index].block_type == "TABLE")

        #puts extractFromBlocksRelation(resp.blocks, resp.blocks[index].relationships[0])

        for x in (0...awsBlocks[index].relationships.length)
          for a in (0...awsBlocks[index].relationships[x].ids.length)
            extrId = awsBlocks[index].relationships[x].ids[a]
            extrBlock = awsBlocks.find { |b| b.id == extrId }

            if extrBlock.relationships.nil? == false
              for b in (0...extrBlock.relationships.length)
                puts getBlocksFromIds(resp.blocks, extrBlock.relationships[b].ids)
              end
            end
          end
        end
      end
    end
  end

  #Helper functions

  def getBlocksFromIds(blocks, ids)
    extractedValue = ""

    for a in (0...ids.length)
      extrId = ids[a]

      extrTxt = blocks.find { |b| b.id == extrId }.text

      if extrTxt.nil? == false
        extractedValue += extrTxt
        extractedValue += " "
      end
    end

    return extractedValue
  end

  def extractFromEntityTypeAndRelation(awsBlocks, block, relationship, entityType, relationType)
    if block.entity_types[0] == entityType && relationship.type == relationType
        return getBlocksFromIds(awsBlocks, relationship.ids)
    else
        return ""
    end
  end

  #Custom extraction functions for each company

  def extractData_kenco(awsBlocks)
    puts extractKeyValuePairs(awsBlocks)
  end

  def extractData_rjw(awsBlocks)
    puts extractKeyValuePairs(awsBlocks)
  end
end
