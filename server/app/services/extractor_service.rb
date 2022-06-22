require "aws-sdk"
require 'json'

class ExtractorService  
  PdfField = Struct.new(:value, :x, :y, :width, :height)
  RateConfData = Struct.new(:salesRep, :customer, :notificationEmail, :loadInstrunctions, :customerLoad, :linehaulRate, :fuelSurcharge, :commodity, :weight, :stopData, keyword_init: true)
  RateConfStopData = Struct.new(:stopType, :pu, :companyName, :address, :phone, :customerAppTimeFrom, :customerAppTimeTo, keyword_init: true)

  def extractData(company, responseBlocks)
    #temporary data to simulate aws response blocks
    #text = File.read("/home/minvydas/Desktop/intern/pdfparser/rateconfocr/server/app/services/data.json")
    #responseBlocks = JSON.parse(text, object_class: OpenStruct)
  
    #text = File.read("/home/rytis/Documents/GitHub/rateconfocr/server/app/services/data.json")
    #responseBlocks = JSON.parse(text, object_class: OpenStruct)

    #Company parameter
    #kenco/rjw
    case company
    when "kenco"
      extractData_kenco(responseBlocks)
    when "rjw"
      extractData_rjw(responseBlocks)
    else
      raise RuntimeError, "You messed up!"
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
    if(tableData[1][2][0].include? "urcharge")
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
      customerAppTimeTo: customerAppTimeTo)
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
      customerAppTimeTo: customerAppTimeTo)

    #put extracted data into final struct
    rateConfData = RateConfData.new(
      customer:customer,
      notificationEmail: notificationEmail,
      customerLoad: customerLoad,
      linehaulRate: linehaulRate,
      fuelSurcharge: fuelSurcharge,
      weight: weight,
      stopData: [pickUpStopData, deliveryStopData]
    )

    
  end

  def extractData_rjw(responseBlocks)
    key_map = {}
    value_map = {}
    block_map = {}

    for block in responseBlocks
      block_id = block.id
      block_map[block_id] = block
      if block.block_type == "KEY_VALUE_SET"
        if block.entity_types[0] == "KEY"
          key_map[block_id] = block
        else
          value_map[block_id] = block
        end
      end
    end

    rjwData = {}
    keys = []
    vals = []

    key_map.each do |block_id, key_block|
      value_block = DataExtractorService.new.findValueBlockRjw(key_block, value_map)
      key = DataExtractorService.new.getTextRjw(key_block, block_map)
      val = DataExtractorService.new.getTextRjw(value_block, block_map)
      keys.push(key)
      vals.push(val)
      if rjwData.key?(key)
        rjwData[key+"1"] = val
        
      else
        rjwData[key] = val
      end
    end

    #main data
    customer = "Rjw"
    notificationEmail = vals[keys.find_index('Email: ')]
    customerLoad = vals[keys.find_index('Pieces \ Spots: ')] 
    linehaulRate = vals[keys.find_index("Total Carrier Pay: ")]
    fuelSurcharge = nil
    weight = vals[keys.find_index("Weight (lbs): ")]

    #pickup data
    indexName = keys.find_index('Name: ')
    indexAddress = keys.find_index('Address: ')
    indexDate = keys.find_index('Date: ')

    stopType = "Pick Up"
    companyName = vals[indexName]
    address = vals[indexAddress]
    if vals[indexDate].nil? == false
      customerAppTimeFrom = vals[indexDate].split(" ")[0] + " " + vals[indexDate].split(" ")[1]
      customerAppTimeTo = vals[indexDate].split(" ")[2] + " " + vals[indexDate].split(" ")[3]
    else
      customerAppTimeFrom = nil
      customerAppTimeTo = nil
    end

    pickUpStopData = RateConfStopData.new(
      stopType: stopType, 
      companyName: companyName, 
      address: address,
      customerAppTimeFrom: customerAppTimeFrom, 
      customerAppTimeTo: customerAppTimeTo)

    #delete used keys and values (because of duplicated keys)
    keys.delete_at(indexName)
    keys.delete_at(indexAddress)
    keys.delete_at(indexDate)

    vals.delete_at(indexName)
    vals.delete_at(indexAddress)
    vals.delete_at(indexDate)

    #stop data
    indexName = keys.find_index('Name: ')
    indexAddress = keys.find_index('Address: ')
    indexDate = keys.find_index('Date: ')

    stopType = "Stop"
    companyName = vals[indexName]
    address = vals[indexAddress]
    if vals[indexDate].nil? == false
      customerAppTimeFrom = vals[indexDate].split(" ")[0] + " " + vals[indexDate].split(" ")[1]
      customerAppTimeTo = vals[indexDate].split(" ")[2] + " " + vals[indexDate].split(" ")[3]
    else
      customerAppTimeFrom = nil
      customerAppTimeTo = nil
    end

    deliveryStopData = RateConfStopData.new(
      stopType: stopType, 
      companyName: companyName, 
      address: address,
      customerAppTimeFrom: customerAppTimeFrom, 
      customerAppTimeTo: customerAppTimeTo)

    rateConfData = RateConfData.new(
      customer:customer,
      notificationEmail: notificationEmail,
      customerLoad: customerLoad,
      linehaulRate: linehaulRate,
      fuelSurcharge: fuelSurcharge,
      weight: weight,
      stopData: [pickUpStopData, deliveryStopData]
    ) 
  end
end