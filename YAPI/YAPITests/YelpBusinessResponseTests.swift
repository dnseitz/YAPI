//
//  YelpBusinessResponseTests.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpBusinessResponseTests: YAPIXCTestCase {
  var requestStub: YelpBusinessRequest!
  
  override func setUp() {
    super.setUp()
    
    requestStub = YelpAPIFactory.makeBusinessRequest(with: "businessId")
  }
  
  func test_ValidResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpValidBusinessResponse)
      let response = YelpBusinessResponse(withJSON: dict, from: requestStub)
      
      XCTAssert(response.businesses!.count == 1)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssert(response.wasSuccessful == true)
      XCTAssertNil(response.error)
    }
    catch {
      XCTFail()
    }
  }
  
  func test_ErrorResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpErrorResponse)
      let response = YelpBusinessResponse(withJSON: dict, from: requestStub)
      
      XCTAssertNil(response.businesses)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssertNotNil(response.error)
      XCTAssert(response.error! == YelpResponseError.InvalidParameter(field: "location"))
      XCTAssert(response.wasSuccessful == false)
    } catch {
      XCTFail()
    }
  }
}
