//
//  YelpAPIFactoryTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/27/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
import CoreLocation
@testable import YAPI

class YelpAPIFactoryTests: YAPIXCTestCase {
  
  var searchRequestStub: YelpV2SearchRequest!
  var businessRequestStub: YelpV2BusinessRequest!
  var phoneSearchRequestStub: YelpV2PhoneSearchRequest!
  
  override func setUp() {
    super.setUp()
    
    searchRequestStub = YelpAPIFactory.V2.makeSearchRequest(with: YelpV2SearchParameters(location: "" as YelpSearchLocation))
    businessRequestStub = YelpAPIFactory.V2.makeBusinessRequest(with: "businessId")
    phoneSearchRequestStub = YelpAPIFactory.V2.makePhoneSearchRequest(with: YelpV2PhoneSearchParameters(phone: "PHONE"))
  }
  
  override func tearDown() {
    YelpAPIFactory.V2.localeParameters = nil
    YelpAPIFactory.V2.actionlinkParameters = nil
    
    super.tearDown()
  }
  
  // MARK: Search Request Tests
  
  func test_Factory_BuildsSearchRequestWithParameters() {
    let params = YelpV2SearchParameters(location: YelpSearchLocation(location: "TEST_LOCATION", locationHint: CLLocation(latitude: 10, longitude: 20)), term: .food, limit: 99, offset: 15, sortMode: .best, categories: ["TEST_CATEGORY1", "TEST_CATEGORY2"], radius: 10000, filterDeals: false)
    let request = YelpAPIFactory.V2.makeSearchRequest(with: params)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["location"] == "TEST_LOCATION")
    XCTAssert(reqParams["cll"] == "10.0,20.0")
    XCTAssert(reqParams["limit"] == "99")
    XCTAssert(reqParams["term"] == "food")
    XCTAssert(reqParams["offset"] == "15")
    XCTAssert(reqParams["sort"] == "0")
    XCTAssert(reqParams["category_filter"] == "TEST_CATEGORY1,TEST_CATEGORY2")
    XCTAssert(reqParams["radius_filter"] == "10000")
    XCTAssert(reqParams["deals_filter"] == "false")
    
    XCTAssertNil(reqParams["cc"])
    XCTAssertNil(reqParams["lang"])
    XCTAssertNil(reqParams["lang_filter"])
    
    XCTAssertNil(reqParams["actionlinks"])
  }
  
  func test_Factory_BuildsSearchRequestWithLocaleParameters() {
    YelpAPIFactory.V2.localeParameters = YelpV2LocaleParameters(countryCode: .unitedStates, language: .english, filterLanguage: true)
    let params = YelpV2SearchParameters(location: YelpSearchLocation(location: "TEST_LOCATION", locationHint: CLLocation(latitude: 10, longitude: 20)), term: .food, limit: 99, offset: 15, sortMode: .best, categories: ["TEST_CATEGORY1", "TEST_CATEGORY2"], radius: 10000, filterDeals: false)
    let request = YelpAPIFactory.V2.makeSearchRequest(with: params)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["location"] == "TEST_LOCATION")
    XCTAssert(reqParams["cll"] == "10.0,20.0")
    XCTAssert(reqParams["limit"] == "99")
    XCTAssert(reqParams["term"] == "food")
    XCTAssert(reqParams["offset"] == "15")
    XCTAssert(reqParams["sort"] == "0")
    XCTAssert(reqParams["category_filter"] == "TEST_CATEGORY1,TEST_CATEGORY2")
    XCTAssert(reqParams["radius_filter"] == "10000")
    XCTAssert(reqParams["deals_filter"] == "false")
    
    XCTAssert(reqParams["cc"] == "US")
    XCTAssert(reqParams["lang"] == "en")
    XCTAssert(reqParams["lang_filter"] == "true")
    
    XCTAssertNil(reqParams["actionlinks"])
  }
  
  func test_Factory_BuildsSearchRequestWithActionlinkParameters() {
    YelpAPIFactory.V2.actionlinkParameters = YelpV2ActionlinkParameters(actionlinks: false)
    let params = YelpV2SearchParameters(location: YelpSearchLocation(location: "TEST_LOCATION", locationHint: CLLocation(latitude: 10, longitude: 20)), term: .food, limit: 99, offset: 15, sortMode: .best, categories: ["TEST_CATEGORY1", "TEST_CATEGORY2"], radius: 10000, filterDeals: false)
    let request = YelpAPIFactory.V2.makeSearchRequest(with: params)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["location"] == "TEST_LOCATION")
    XCTAssert(reqParams["cll"] == "10.0,20.0")
    XCTAssert(reqParams["limit"] == "99")
    XCTAssert(reqParams["term"] == "food")
    XCTAssert(reqParams["offset"] == "15")
    XCTAssert(reqParams["sort"] == "0")
    XCTAssert(reqParams["category_filter"] == "TEST_CATEGORY1,TEST_CATEGORY2")
    XCTAssert(reqParams["radius_filter"] == "10000")
    XCTAssert(reqParams["deals_filter"] == "false")
    
    XCTAssertNil(reqParams["cc"])
    XCTAssertNil(reqParams["lang"])
    XCTAssertNil(reqParams["lang_filter"])
    
    XCTAssert(reqParams["actionlinks"] == "false")
  }
  
  func test_Factory_BuildsSearchRequestWithMinimalParameters() {
    let params = YelpV2SearchParameters(location: "TEST_LOCATION" as YelpSearchLocation)
    let request = YelpAPIFactory.V2.makeSearchRequest(with: params)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["location"] == "TEST_LOCATION")
    XCTAssertNil(reqParams["cll"])
    XCTAssertNil(reqParams["limit"])
    XCTAssertNil(reqParams["term"])
    XCTAssertNil(reqParams["offset"])
    XCTAssertNil(reqParams["sort"])
    XCTAssertNil(reqParams["category_filter"])
    XCTAssertNil(reqParams["radius_filter"])
    XCTAssertNil(reqParams["deals_filter"])
    
    XCTAssertNil(reqParams["cc"])
    XCTAssertNil(reqParams["lang"])
    XCTAssertNil(reqParams["lang_filter"])
    
    XCTAssertNil(reqParams["actionlinks"])
  }
  
  // MARK: Business Request Tests
  
  func test_Factory_BuildsBusinessRequestWithBusinessId() {
    let request = YelpAPIFactory.V2.makeBusinessRequest(with: "businessId")
    let reqParams = request.parameters
    
    XCTAssert(reqParams.count == 0)
    XCTAssert(request.path == YelpEndpoints.V2.business + "businessId")
  }
  
  func test_Factory_BuildsBusinessRequestWithLocaleParameters() {
    YelpAPIFactory.V2.localeParameters = YelpV2LocaleParameters(countryCode: .unitedStates, language: .english, filterLanguage: true)
    let request = YelpAPIFactory.V2.makeBusinessRequest(with: "businessId")
    let reqParams = request.parameters
    
    XCTAssert(request.path == YelpEndpoints.V2.business + "businessId")
    
    XCTAssert(reqParams["cc"] == "US")
    XCTAssert(reqParams["lang"] == "en")
    XCTAssert(reqParams["lang_filter"] == "true")
    
    XCTAssertNil(reqParams["actionlinks"])
  }
  
  func test_Factory_BuildsBusinessRequestWithActionlinkParameters() {
    YelpAPIFactory.V2.actionlinkParameters = YelpV2ActionlinkParameters(actionlinks: true)
    let request = YelpAPIFactory.V2.makeBusinessRequest(with: "businessId")
    let reqParams = request.parameters
    
    XCTAssert(request.path == YelpEndpoints.V2.business + "businessId")
    
    XCTAssertNil(reqParams["cc"])
    XCTAssertNil(reqParams["lang"])
    XCTAssertNil(reqParams["lang_filter"])
    
    XCTAssert(reqParams["actionlinks"] == "true")
  }
  
  // MARK: Phone Search Request Tests
  
  func test_Factory_BuildsPhoneSearchRequestWithParameters() {
    let request = YelpAPIFactory.V2.makePhoneSearchRequest(with: YelpV2PhoneSearchParameters(phone: "PHONE", countryCode: .canada, category: "CATEGORY"))
    let reqParams = request.parameters
    
    XCTAssert(reqParams["phone"] == "PHONE")
    XCTAssert(reqParams["cc"] == "CA")
    XCTAssert(reqParams["category"] == "CATEGORY")
  }
  
  func test_Factory_BuildsPhoneSearchRequestWithMinimalParameters() {
    let request = YelpAPIFactory.V2.makePhoneSearchRequest(with: YelpV2PhoneSearchParameters(phone: "PHONE"))
    let reqParams = request.parameters
    
    XCTAssert(reqParams["phone"] == "PHONE")
    XCTAssertNil(reqParams["cc"])
    XCTAssertNil(reqParams["category"])
  }
  
  // MARK: Response Tests
  
  func test_Factory_BuildsResponseWithValidJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpValidThreeBusinessResponse)
      let response = YelpAPIFactory.makeResponse(withJSON: dict, from: searchRequestStub)!
      
      XCTAssert(response is YelpV2SearchResponse)
      XCTAssert(response.wasSuccessful == true)
      XCTAssert(response.error == nil)
    } catch {
      XCTFail()
    }
  }
  
  func test_Factory_BuildsResponseWithErrorJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpErrorResponse)
      let response = YelpAPIFactory.makeResponse(withJSON: dict, from: searchRequestStub)!
      
      XCTAssert(response is YelpV2SearchResponse)
      XCTAssertNotNil(response.error)
      XCTAssert(response.error! == .invalidParameter(field: "location"))
      XCTAssert(response.wasSuccessful == false)
    } catch {
      XCTFail()
    }
  }
  
  func test_Factory_BuildsResponseWithValidNSData() {
    let data = Data(base64Encoded: ResponseInjections.yelpValidThreeBusinessResponse, options: .ignoreUnknownCharacters)!
    let response = YelpAPIFactory.makeResponse(with: data, from: searchRequestStub)
    
    XCTAssertNotNil(response)
    XCTAssert(response is YelpV2SearchResponse)
    XCTAssert(response!.wasSuccessful == true)
    XCTAssert(response!.error == nil)
  }
  
  func test_Factory_BuildsResponseWithErrorNSData() {
    let data = Data(base64Encoded: ResponseInjections.yelpErrorResponse, options: .ignoreUnknownCharacters)!
    let response = YelpAPIFactory.makeResponse(with: data, from: searchRequestStub)
    
    XCTAssertNotNil(response)
    XCTAssert(response is YelpV2SearchResponse)
    XCTAssertNotNil(response!.error)
    XCTAssert(response!.error! == .invalidParameter(field: "location"))
    XCTAssert(response!.wasSuccessful == false)
  }
  
  func test_Factory_BuildsNilWithInvalidNSData() {
    let data = Data()
    let response = YelpAPIFactory.makeResponse(with: data, from: searchRequestStub)
    
    XCTAssertNil(response)
  }
  
  func test_Factory_BuildsCorrectTypeOfResponseBasedOnRequest() {
    let searchData = Data(base64Encoded: ResponseInjections.yelpValidOneBusinessResponse, options: .ignoreUnknownCharacters)!
    let businessData = Data(base64Encoded: ResponseInjections.yelpValidBusinessResponse, options: .ignoreUnknownCharacters)!
    let phoneSearchData = Data(base64Encoded: ResponseInjections.yelpValidPhoneSearchResponse, options: .ignoreUnknownCharacters)!
    
    let searchResponse = YelpAPIFactory.makeResponse(with: searchData, from: searchRequestStub)
    let businessResponse = YelpAPIFactory.makeResponse(with: businessData, from: businessRequestStub)
    let phoneSearchResponse = YelpAPIFactory.makeResponse(with: phoneSearchData, from: phoneSearchRequestStub)
    
    XCTAssertNotNil(searchResponse)
    XCTAssertNotNil(businessResponse)
    XCTAssertNotNil(phoneSearchResponse)
    
    XCTAssert(searchResponse is YelpV2SearchResponse)
    XCTAssert(businessResponse is YelpV2BusinessResponse)
    XCTAssert(phoneSearchResponse is YelpV2PhoneSearchResponse)
  }
}
