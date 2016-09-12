//
//  YelpPhoneSearchResponseTests.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/12/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpPhoneSearchResponseTests: YAPIXCTestCase {
  
  var requestStub: YelpPhoneSearchRequest!

  override func setUp() {
    super.setUp()
    
    requestStub = YelpAPIFactory.makePhoneSearchRequest(with: YelpPhoneSearchParameters(phone: "PHONE"))
  }
  
  func test_ValidResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpValidPhoneSearchResponse)
      let response = YelpSearchResponse(withJSON: dict, from: requestStub)
      
      XCTAssertNil(response.region)
      XCTAssertNotNil(response.total)
      XCTAssert(response.total == 2316)
      XCTAssertNotNil(response.businesses)
      XCTAssert(response.businesses!.count == 1)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssert(response.wasSuccessful == true)
      XCTAssert(response.error == nil)
    }
    catch {
      XCTFail()
    }
  }
  
  func test_ErrorResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpErrorResponse)
      let response = YelpSearchResponse(withJSON: dict, from: requestStub)
      
      XCTAssertNil(response.region)
      XCTAssertNil(response.total)
      XCTAssertNil(response.businesses)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssertNotNil(response.error)
      XCTAssert(response.error! == YelpResponseError.InvalidParameter(field: "location"))
      XCTAssert(response.wasSuccessful == false)
    }
    catch {
      XCTFail()
    }
  }
}
