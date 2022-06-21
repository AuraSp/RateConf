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
    extractedData = []
    #buffer 2d array
    extractedArray = Array.new(10) { Array.new(10) { } }
    mainblocks = nil
    mainblocks = getBlocks(awsBlocks, awsBlocks[0].relationships[0].ids)
    tableBlocks = mainblocks.select { |b| b.block_type == "TABLE" && b.relationships.nil? == false }

    tableBlocks.each do |block|
      block.relationships.each do |blockRelationships|
        cellBlocks = getBlocks(awsBlocks, blockRelationships.ids)
        cellBlocks = cellBlocks.select { |c| c.relationships.nil? == false }
        cellBlocks.each do |cellBlock|
          cellBlock.relationships.each do |cellRelation|
            blocksFromId = getBlocks(awsBlocks, cellRelation.ids)
            extractedArray[cellBlock.row_index-1][cellBlock.column_index-1] = getTextFromBlocks(blocksFromId)
          end
        end
      end
      extractedData.push(extractedArray.map(&:compact).reject(&:empty?))
      extractedArray = Array.new(10) { Array.new(10) { } }
    end

    return extractedData
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

  def findValueBlockRjw(key_block, value_map)
    for relationship in key_block.relationships
      if relationship.type == 'VALUE'
        for value_id in relationship.ids
          value_block = value_map[value_id]
        end
      end
    end
    return value_block
  end

  def getTextRjw(result, blocks_map)
    text = ''
    a = result.relationships
    if a.nil?
      return "nil"
    end
    if 'Relationships' in result
      for relationship in a
        if relationship.type == 'CHILD'
          for child_id in relationship.ids
            word = blocks_map[child_id]
            if word.block_type == 'WORD'
              text += word.text + ' '
            end
            if word.block_type == 'SELECTION_ELEMENT'
              if word.selection_status == 'SELECTED'
                text += 'X '
              end
            end
          end
        end
      end
    end
    return text
  end
end
