require "aws-sdk"

class DataExtractorService
#Main functions

  #extract function returning key value pairs
  def extractKeyValuePairs(awsBlocks)
    extractedKey = ""
    prevExtractedKey = ""
    extractedValue = ""

    keyValueHash = Hash.new("pair")

    keyValueBlocks = awsBlocks.select { |b| b.block_type == "KEY_VALUE_SET" && b.relationships.nil? == false }

    keyValueBlocks.each do |block|
      block.relationships.each do |relationship|
        extractedKey = extractFromEntityTypeAndRelation(awsBlocks, block, relationship, "KEY", "CHILD")
        extractedValue = extractFromEntityTypeAndRelation(awsBlocks, block, relationship, "VALUE", "CHILD")
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
    return keyValueHash
  end

  #extract function returning tables
  #very shit currently
  def extractKeyTableData(awsBlocks)
    tableBlocks = awsBlocks.select { |b| b.block_type == "TABLE" && b.relationships.nil? == false }
    tableBlocks.each do |block|
      block.relationships.each do |blockRelationships|
        cellBlocks = getBlocks(awsBlocks, blockRelationships.ids)
        cellBlocks = cellBlocks.select { |c| c.relationships.nil? == false }
        cellBlocks.each do |cellBlock|
          cellBlock.relationships.each do |cellRelation|
            blocksFromId = getBlocks(awsBlocks, cellRelation.ids)
            puts getTextFromBlocks(blocksFromId)
          end
        end
      end
    end
  end

  #Helper functions
  def getBlocks(blocks, ids)
    blocksFromId = Array.new

    ids.each do |id|
      blockFromId = blocks.find { |b| b.id == id }
      if blockFromId.nil? == false
        blocksFromId.push(blockFromId)
      end
    end
    return blocksFromId
  end

  def getTextFromBlocks(blocks)
    extractedValue = ""
    blocks.each do |block|
      if block.text.nil? == false
        extractedValue += block.text
        extractedValue += " "
      end
    end

    return extractedValue
  end

  def extractFromEntityTypeAndRelation(awsBlocks, block, relationship, entityType, relationType)
    if block.entity_types[0] == entityType && relationship.type == relationType
      extractedBlocks = getBlocks(awsBlocks, relationship.ids)
      return getTextFromBlocks(extractedBlocks)
    else
      return ""
    end
  end
end
