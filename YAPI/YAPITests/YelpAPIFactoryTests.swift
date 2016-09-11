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
  
  var requestStub: YelpSearchRequest!
  
  override func setUp() {
    super.setUp()
    
    requestStub = YelpAPIFactory.makeSearchRequest()
  }
  
  func test_Factory_BuildsRequestWithParamStruct() {
    let params = YelpSearchParameters(location: "TEST_LOCATION", currentLocation: CLLocation(latitude: 10, longitude: 20), limit: 99, term: .Food, offset: 15, sortMode: .Best, category: ["TEST_CATEGORY1", "TEST_CATEGORY2"], radius: 10000, filterDeals: false)
    let request = YelpAPIFactory.makeSearchRequest(with: params)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["location"] == "TEST_LOCATION")
    XCTAssert(reqParams["cl"] == "10.0,20.0")
    XCTAssert(reqParams["limit"] == "99")
    XCTAssert(reqParams["term"] == "food")
    XCTAssert(reqParams["offset"] == "15")
    XCTAssert(reqParams["sort"] == "0")
    XCTAssert(reqParams["category_filter"] == "TEST_CATEGORY1,TEST_CATEGORY2")
    XCTAssert(reqParams["radius_filter"] == "10000")
    XCTAssert(reqParams["deals_filter"] == "false")
  }
  
  func test_Factory_BuildsRequestWithParamValues() {
    let request = YelpAPIFactory.makeSearchRequest(withLocation: "TEST_LOCATION", withLimit: 99, withTerm: .Food, withOffset: 15, sortBy: .Best, withCategory: ["TEST_CATEGORY1", "TEST_CATEGORY2"], withRadiusInMeters: 10000, filterDeals: false)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["location"] == "TEST_LOCATION")
    XCTAssert(reqParams["limit"] == "99")
    XCTAssert(reqParams["term"] == "food")
    XCTAssert(reqParams["offset"] == "15")
    XCTAssert(reqParams["sort"] == "0")
    XCTAssert(reqParams["category_filter"] == "TEST_CATEGORY1,TEST_CATEGORY2")
    XCTAssert(reqParams["radius_filter"] == "10000")
    XCTAssert(reqParams["deals_filter"] == "false")
  }
  
  func test_Factory_BuildsRequestWithoutLocation() {
    let request = YelpAPIFactory.makeSearchRequest(currentLocation: CLLocation(latitude: 10, longitude: 20), withLimit: 99, withTerm: .Food, withOffset: 15, sortBy: .Best, withCategory: ["TEST_CATEGORY1", "TEST_CATEGORY2"], withRadiusInMeters: 10000, filterDeals: false)
    let reqParams = request.parameters
    
    XCTAssert(reqParams["ll"] == "10.0,20.0")
    XCTAssert(reqParams["limit"] == "99")
    XCTAssert(reqParams["term"] == "food")
    XCTAssert(reqParams["offset"] == "15")
    XCTAssert(reqParams["sort"] == "0")
    XCTAssert(reqParams["category_filter"] == "TEST_CATEGORY1,TEST_CATEGORY2")
    XCTAssert(reqParams["radius_filter"] == "10000")
    XCTAssert(reqParams["deals_filter"] == "false")
  }
  
  func test_Factory_BuildsResponseWithValidJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpValidThreeBusinessResponse)
      let response = YelpAPIFactory.makeResponse(withJSON: dict, from: requestStub)
      
      XCTAssert(response.businesses.count == 3)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssert(response.wasSuccessful == true)
      XCTAssert(response.error == nil)
    } catch {
      XCTFail()
    }
  }
  
  func test_Factory_BuildsResponseWithErrorJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpErrorResponse)
      let response = YelpAPIFactory.makeResponse(withJSON: dict, from: requestStub)
      
      XCTAssert(response.businesses.count == 0)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssertNotNil(response.error)
      XCTAssert(response.error! == YelpResponseError.InvalidParameter(field: "location"))
      XCTAssert(response.wasSuccessful == false)
    } catch {
      XCTFail()
    }
  }
  
  func test_Factory_BuildsResponseWithValidNSData() {
    let data = NSData(base64EncodedString: ResponseInjections.yelpValidThreeBusinessResponse, options: .IgnoreUnknownCharacters)!
    let response = YelpAPIFactory.makeResponse(with: data, from: requestStub)
    
    XCTAssertNotNil(response)
    XCTAssert(response!.businesses.count == 3)
    XCTAssert(requestStub === (response!.request as! AnyObject))
    XCTAssert(response!.wasSuccessful == true)
    XCTAssert(response!.error == nil)
  }
  
  func test_Factory_BuildsResponseWithErrorNSData() {
    let data = NSData(base64EncodedString: ResponseInjections.yelpErrorResponse, options: .IgnoreUnknownCharacters)!
    let response = YelpAPIFactory.makeResponse(with: data, from: requestStub)
    
    XCTAssertNotNil(response)
    XCTAssert(response!.businesses.count == 0)
    XCTAssert(requestStub === (response!.request as! AnyObject))
    XCTAssertNotNil(response!.error)
    XCTAssert(response!.error! == YelpResponseError.InvalidParameter(field: "location"))
    XCTAssert(response!.wasSuccessful == false)
  }
  
  func test_Factory_BuildsNilWithInvalidNSData() {
    let data = NSData()
    let response = YelpAPIFactory.makeResponse(with: data, from: requestStub)
    
    XCTAssertNil(response)
  }
  
}
