//
//  YelpResponseModelTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/26/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpResponseModelTests: YAPIXCTestCase {
  
  var requestStub: YelpSearchRequest!
  
  override func setUp() {
    super.setUp()
    
    requestStub = YelpAPIFactory.makeSearchRequest(with: YelpSearchParameters(location: "" as YelpSearchLocation))
  }
  
  func test_ValidResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpValidThreeBusinessResponse)
      let response = YelpSearchResponse(withJSON: dict, from: requestStub)
      
      XCTAssert(response.businesses!.count == 3)
      XCTAssert(requestStub === (response.request as! AnyObject))
      XCTAssert(response.wasSuccessful == true)
      XCTAssert(response.error == nil)
    } catch {
      XCTFail()
    }
  }
  
  func test_ErrorResponse_ParsedFromEncodedJSON() {
    do {
      let dict = try self.dictFromBase64(ResponseInjections.yelpErrorResponse)
      let response = YelpSearchResponse(withJSON: dict, from: requestStub)
      
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
