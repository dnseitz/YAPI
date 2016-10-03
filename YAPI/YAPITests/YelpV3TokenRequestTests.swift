//
//  YelpV3TokenRequestTests.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpV3TokenRequestTests: YAPIXCTestCase {
  var session: YelpHTTPClient!
  var request: YelpV3TokenRequest!
  let mockSession = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    session = YelpHTTPClient(session: mockSession)
    request = YelpV3TokenRequest(token: YelpV3TokenParameters(grantType: .clientCredentials, clientId: "CLIENTID", clientSecret: "CLIENTSECRET"), session: session)
  }
  
  func test_SendRequest_RecievesData_ParsesTheData() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidTokenRequestResponse, options: .ignoreUnknownCharacters)
    request.send { (response, error) in
      XCTAssertNotNil(response)
      XCTAssertNil(error)
      
      guard let response = response else {
        XCTFail()
        return
      }
      
      XCTAssert(response.wasSuccessful)
      XCTAssert(response.accessToken == "your access token")
      XCTAssert(response.tokenType == .bearer)
      XCTAssert(response.expiresIn == 15552000)
    }
  }
}
