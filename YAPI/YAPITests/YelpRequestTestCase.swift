//
//  YelpRequestTestCase.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpV2GenericRequestTestCase : YAPIXCTestCase {
  var session: YelpHTTPClient!
  var request: YelpV2BusinessRequest!
  let mockSession = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    session = YelpHTTPClient(session: mockSession)
    request = YelpV2BusinessRequest(businessId: "", session: session)
  }
  
  override func tearDown() {
    mockSession.nextData = nil
    mockSession.nextError = nil
    
    super.tearDown()
  }
  
  func test_SendRequest_WhereRequestErrors_GivesTheError() {
    let mockError = NSError(domain: "error", code: 0, userInfo: nil)
    mockSession.nextError = mockError
    request.send() { result in
      XCTAssert(result.isErr())
      
      XCTAssert(result.unwrapErr() as! YelpRequestError == .failedToSendRequest(mockError))
    }
  }
  
  func test_SendRequest_RecievesNoData_GivesAnError() {
    request.send() { result in
      XCTAssert(result.isErr())
      
      XCTAssert(result.unwrapErr() as! YelpResponseError == .noDataRecieved)
    }
  }
  
  func test_SendRequest_RecievesBadData_GivesAnError() {
    mockSession.nextData = Data()
    request.send() { result in
      XCTAssert(result.isErr())
      
      XCTAssert(result.unwrapErr() as! YelpResponseError == .failedToParse(cause: .invalidJson))
    }
  }
  
  func test_SendRequest_RecievesYelpError_GivesTheError() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpErrorResponse, options: .ignoreUnknownCharacters)
    request.send() { result in
      XCTAssert(result.isOk())
      let response = result.unwrap()
      
      XCTAssertNil(response.businesses)
      XCTAssertNotNil(response.error)
      XCTAssert(response.error! == .invalidParameter(field: "location"))
      XCTAssert(response.wasSuccessful == false)
    }
  }
}
