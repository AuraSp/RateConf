require "aws-sdk"

class ExtractorService  
  PdfField = Struct.new(:value, :x, :y, :width, :height)
  RateConfData = Struct.new(:salesRep, :customer, :notificationEmail, :loadInstrunctions, :customerLoad, :linehaulRate, :fuelSurcharge, :commodity, :weight, :stopData, keyword_init: true)
  RateConfStopData = Struct.new(:stopType, :pu, :companyName, :address, :phone, :customerAppTimeFrom, :customerAppTimeTo, keyword_init: true)

  def extractData(company, responseBlocks=nil)
    #temporary data to simulate aws response blocks
    text = File.read("/home/minvydas/Desktop/intern/pdfparser/rateconfocr/server/app/services/data.json")
    responseBlocks = JSON.parse(text, object_class: OpenStruct)
    
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
    #array of 2d arrays(tables)
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

  def extractData_rjw(awsBlocks)
    puts extractKeyValuePairs(awsBlocks)
  end
end