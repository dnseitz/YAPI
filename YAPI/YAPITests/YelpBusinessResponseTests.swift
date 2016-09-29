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
  var requestStub: YelpV2BusinessRequest!
  
  override func setUp() {
    super.setUp()
    
    requestStub = YelpAPIFactory.V2.makeBusinessRequest(with: "businessId")
  }
  
  func test_ValidResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpValidBusinessResponse)
      let response = YelpV2BusinessResponse(withJSON: dict)
      
      XCTAssert(response.businesses!.count == 1)
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
      let response = YelpV2BusinessResponse(withJSON: dict)
      
      XCTAssertNil(response.businesses)
      XCTAssertNotNil(response.error)
      XCTAssert(response.error! == .invalidParameter(field: "location"))
      XCTAssert(response.wasSuccessful == false)
    } catch {
      XCTFail()
    }
  }
}
