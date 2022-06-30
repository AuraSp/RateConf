require "test_helper"

class ExtractorServiceTest < ActiveSupport::TestCase
  test "correct data should be extracted for kenco pdf" do
		text = File.read(Rails.root.to_s + "/test/fixtures/files/kenco_blocks.json")
    responseBlocks = JSON.parse(text, object_class: OpenStruct)

    extractedData = ExtractorService.new.extractData("kenco", responseBlocks)

    #compare data
    pickUpStopData = ExtractorService::RateConfStopData.new(
      stopType: "Pick Up",
      companyName: "Griffith Foods Inc",
      address: " ONE GRIFFITH CENTER,  ALSIP,  IL 60803 ",
      customerAppTimeFrom: "06/02/2022 08:00 AM",
      customerAppTimeTo: "06/02/2022 05:00 PM ",
    )

    deliveryStopData = ExtractorService::RateConfStopData.new(
      stopType: "Delivery",
      companyName: "Griffith Foods Inc",
      address: " 2165 Lithonia Industrial BLVD,  Lithonia,  GA 30058 ",
      customerAppTimeFrom: "06/03/2022 08:00 AM",
      customerAppTimeTo: "06/03/2022 05:00 PM ",
    )

    compareData = ExtractorService::RateConfData.new(
      customer: "Kenco",
      notificationEmail: "Katrina.Green@kencogroup.com ",
      customerLoad: "TM10427905 ",
      linehaulRate: "$2175.0 ",
      fuelSurcharge: "$619.06 ",
      weight: "41900.0 ",
      stopData: [pickUpStopData, deliveryStopData]
    )

    assert_equal(compareData, extractedData)
  end

  test "correct data should be extracted for rjw pdf" do
    text = File.read(Rails.root.to_s + "/test/fixtures/files/rjw_blocks.json")
    responseBlocks = JSON.parse(text, object_class: OpenStruct)

    extractedData = ExtractorService.new.extractData("rjw", responseBlocks)

    #compare data
    pickUpStopData = ExtractorService::RateConfStopData.new(
      stopType: "Pick Up",
      companyName: "MENNEX MILLING",
      address: "425 S. UNION ST.",
      customerAppTimeFrom: "04/13/2022 0800",
      customerAppTimeTo: "04/13/2022 1500",
    )

    deliveryStopData = ExtractorService::RateConfStopData.new(
      stopType: "Stop",
      companyName: "RJW RETAIL SERVICES W07",
      address: "1000 Veterans Parkway",
      customerAppTimeFrom: "04/14/2022 0700",
      customerAppTimeTo: "04/14/2022 1500",
    )

    compareData = ExtractorService::RateConfData.new(
      customer: "Rjw",
      notificationEmail: "DGenualdi@rjwgroup.com ",
      customerLoad: "30 \\ 30 ",
      linehaulRate: "$1,100.00 ",
      fuelSurcharge: nil,
      weight: "40000.0 ",
      stopData: [pickUpStopData, [deliveryStopData]]
    )

    assert_equal(compareData, extractedData)
  end
end
