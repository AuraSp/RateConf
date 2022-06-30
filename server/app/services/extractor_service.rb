require "aws-sdk"
require 'json'
require 'date'

class ExtractorService
  PdfField = Struct.new(:value, :x, :y, :width, :height)
  RateConfData = Struct.new(:salesRep, :customer, :notificationEmail, :loadInstrunctions, :customerLoad, :linehaulRate, :fuelSurcharge, :commodity, :weight, :stopData, keyword_init: true)
  RateConfStopData = Struct.new(:stopType, :pu, :companyName, :address, :phone, :customerAppTimeFrom, :customerAppTimeTo, keyword_init: true)

  def extractData(company, responseBlocks)
    #Company parameter
    #kenco/rjw
    case company
    when "kenco"
      extractData_kenco(responseBlocks)
    when "rjw"
      extractData_rjw(responseBlocks)
    else
      raise RuntimeError
    end
  end

  #Custom extraction functions for each company
  #Probably will change to custom config files
  def extractData_kenco(awsBlocks)
    #hash set
    keyValuePairs = DataExtractorService.new.extractKeyValuePairs(awsBlocks)

    #pdfData of 2d pdfDatas(tables)
    tableData = DataExtractorService.new.extractKeyTableData(awsBlocks)

    #extracted data
    customer = "Kenco"
    notificationEmail = keyValuePairs["Remit Email: "]
    customerLoad = keyValuePairs["Load Number: "]
    linehaulRate = tableData[1][1][2]
    if (tableData[1][2][0].include? "urcharge")
      fuelSurcharge = tableData[1][2][3]
    else
      fuelSurcharge = 0
    end
    weight = keyValuePairs["Weight "]

    #pick up stop data
    stopType = "Pick Up"
    companyName = keyValuePairs["Origin: "].split(",")[0]
    address = keyValuePairs["Origin: "].split(",")[1..-1].join(", ").remove("phone: ").remove("email: ")
    customerAppTimeFrom = keyValuePairs["Pickup: "].split(" - ")[0]
    customerAppTimeTo = keyValuePairs["Pickup: "].split(" - ")[1]

    pickUpStopData = RateConfStopData.new(
      stopType: stopType,
      companyName: companyName,
      address: address,
      customerAppTimeFrom: customerAppTimeFrom,
      customerAppTimeTo: customerAppTimeTo,
    )
    #delivery stop data
    stopType = "Delivery"
    companyName = keyValuePairs["Destination: "].split(",")[0]
    address = keyValuePairs["Destination: "].split(",")[1..-1].join(", ").remove("phone: ").remove("email: ")
    customerAppTimeFrom = keyValuePairs["Delivery: "].split(" - ")[0]
    customerAppTimeTo = keyValuePairs["Delivery: "].split(" - ")[1]

    deliveryStopData = RateConfStopData.new(
      stopType: stopType,
      companyName: companyName,
      address: address,
      customerAppTimeFrom: customerAppTimeFrom,
      customerAppTimeTo: customerAppTimeTo,
    )

    #put extracted data into final struct
    rateConfData = RateConfData.new(
      customer: customer,
      notificationEmail: notificationEmail,
      customerLoad: customerLoad,
      linehaulRate: linehaulRate,
      fuelSurcharge: fuelSurcharge,
      weight: weight,
      stopData: [pickUpStopData, deliveryStopData],
    )
  end

  def extractData_rjw(responseBlocks)
    key_map = {}
    value_map = {}
    block_map = {}

    keys_map = []
    values_text = []

    found = false
    i = 0

    for block in responseBlocks
      temp_text = block.text
      type = block.block_type

      if temp_text.nil? == false
        if found == true
          values_text.push(temp_text)
          tempResponse = responseBlocks[i+3].text
          if validate_date?(tempResponse)
            values_text.push(tempResponse)
          end
          found = false
        end
        if temp_text["Name:"] || temp_text["Address:"] || temp_text["Date:"]
          if type == "LINE"
            keys_map.push(temp_text)
            found = true
          end
        end
      end
      block_id = block.id
      block_map[block_id] = block
      if block.block_type == "KEY_VALUE_SET"
        if block.entity_types[0] == "KEY"
          key_map[block_id] = block
        else
          value_map[block_id] = block
        end
      end
      i = i + 1
    end
    rjwData = {}
    keys = []
    values_map = []

    key_map.each do |block_id, key_block|
      value_block = DataExtractorService.new.findValueBlockRjw(key_block, value_map)
      key = DataExtractorService.new.getTextRjw(key_block, block_map)
      val = DataExtractorService.new.getTextRjw(value_block, block_map)
      keys.push(key)
      values_map.push(val)
      if rjwData.key?(key)
        rjwData[key + "1"] = val
      else
        rjwData[key] = val
      end
    end

    customer = "Rjw"
    notificationEmail = values_map[keys.find_index("Email: ")]
    customerLoad = values_map[keys.find_index('Pieces \ Spots: ')]
    linehaulRate = values_map[keys.find_index("Total Carrier Pay: ")]
    fuelSurcharge = nil
    weight = values_map[keys.find_index("Weight (lbs): ")]

    #pickup data
    indexName = keys_map.find_index("Name:")
    indexAddress = keys_map.find_index("Address:")
    indexDate = keys_map.find_index("Date:")

    stopType = "Pick Up"
    companyName = values_text[indexName]
    address = values_text[indexAddress + 1]
    if values_text[indexDate].nil? == false
      customerAppTimeFrom = values_text[indexDate]
      customerAppTimeTo = values_text[indexDate + 1]
    else
      customerAppTimeFrom = nil
      customerAppTimeTo = nil
    end

    pickUpStopData = RateConfStopData.new(
      stopType: stopType,
      companyName: companyName,
      address: address,
      customerAppTimeFrom: customerAppTimeFrom,
      customerAppTimeTo: customerAppTimeTo,
    )

    #delete used keys and values (because of duplicated keys)
    keys_map.delete_at(0)
    keys_map.delete_at(0)
    keys_map.delete_at(0)

    values_text.delete_at(0)
    values_text.delete_at(0)
    values_text.delete_at(0)
    values_text.delete_at(0)

    deliveryStopData = []
    while keys_map.include? "Name:"
      indexName = keys_map.find_index("Name:")
      indexAddress = keys_map.find_index("Address:")
      indexDate = keys_map.find_index("Date:")

      if validate_date?(values_text[indexDate + 1])
        stopType = "Stop"
        companyName = values_text[indexName]
        address = values_text[indexAddress + 1]
        if values_text[indexDate].nil? == false
          customerAppTimeFrom = values_text[indexDate]
          customerAppTimeTo = values_text[indexDate + 1]
        else
          customerAppTimeFrom = nil
          customerAppTimeTo = nil
        end

        deliveryStop = RateConfStopData.new(
          stopType: stopType,
          companyName: companyName,
          address: address,
          customerAppTimeFrom: customerAppTimeFrom,
          customerAppTimeTo: customerAppTimeTo,
        )

        deliveryStopData.push(deliveryStop)

        puts deliveryStopData

        keys_map.delete_at(0)
        keys_map.delete_at(0)
        keys_map.delete_at(0)

        values_text.delete_at(0)
        values_text.delete_at(0)
        values_text.delete_at(0)
        values_text.delete_at(0)
      else
        keys_map.delete_at(0)
        keys_map.delete_at(0)
        keys_map.delete_at(0)

        values_text.delete_at(0)
        values_text.delete_at(0)
        values_text.delete_at(0)
      end
    end

    rateConfData = RateConfData.new(
      customer: customer,
      notificationEmail: notificationEmail,
      customerLoad: customerLoad,
      linehaulRate: linehaulRate,
      fuelSurcharge: fuelSurcharge,
      weight: weight,
      stopData: [pickUpStopData, deliveryStopData],
    )
  end

  def validate_date?(str, format="%m/%d/%Y")
    Date.strptime(str, format) rescue false
  end
end
