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
    #awsBlocks = File.read('/home/minvydas/Desktop/intern/pdfparser/rateconfocr/server/app/services/temp.json')
    #responseBlocks = JSON.parse(awsBlocks, object_class: OpenStruct)
    blocks = responseBlocks.select { |b| b.block_type == "LINE"}

    pdfData = []
    blocks.each do |block|
      pdfData.push(block.text)
    end


    customer = "Rjw"
    notificationEmail = pdfData[11].split.last
    customerLoad = pdfData[9] 
    linehaulRate = pdfData[55].split.last.tr('$', '')
    weight = pdfData[56].split.last
    fuelSurcharge = nil
    
    #pickup data
    stopType = "Pick Up"
    companyName = pdfData[70]
    address = pdfData[74]
    customerAppTimeFrom = pdfData[72].insert(13, ':')
    customerAppTimeTo = pdfData[75].insert(13, ':')

    pickUpStopData = RateConfStopData.new(
      stopType: stopType, 
      companyName: companyName, 
      address: address,
      customerAppTimeFrom: customerAppTimeFrom, 
      customerAppTimeTo: customerAppTimeTo)

    #stop data
    stopCompany = 87
    stopAddress = 91
    stopFrom = 89
    stopTo = 92

    stopType = "Delivery"
    companyName = pdfData[stopCompany]
    address = pdfData[stopAddress]
    customerAppTimeFrom = pdfData[stopFrom].insert(13, ':')
    customerAppTimeTo = pdfData[stopTo].insert(13, ':')

    deliveryStopData = RateConfStopData.new(
      stopType: stopType, 
      companyName: companyName, 
      address: address,
      customerAppTimeFrom: customerAppTimeFrom, 
      customerAppTimeTo: customerAppTimeTo)


    #if there are any more stops // +20 for each stop
    stop = 85

    while pdfData[stop+20].include? "so"
      stopCompany += 20
      stopAddress += 20
      stopFrom += 20
      stopTo += 20

      stopType = "Delivery"
      companyName = pdfData[stopCompany]
      address = pdfData[stopAddress]
      customerAppTimeFrom = pdfData[stopFrom].insert(13, ':')
      customerAppTimeTo = pdfData[stopTo].insert(13, ':')

      deliveryStopData = RateConfStopData.new(
      stopType: stopType, 
      companyName: companyName, 
      address: address,
      customerAppTimeFrom: customerAppTimeFrom, 
      customerAppTimeTo: customerAppTimeTo)

      stop += 20
    end
    
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