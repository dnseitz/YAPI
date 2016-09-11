//
//  YelpHTTPClientTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpHTTPClientTests: YAPIXCTestCase {
  var subject: YelpHTTPClient!
  let session = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    subject = YelpHTTPClient(session: session)
  }
  
  override func tearDown() {
    session.nextData = nil
    session.nextError = nil
    
    super.tearDown()
  }
  
  func test_Send_RequestsTheURL() {
    let url = NSURL(string: "http://yelp.com")!
    
    subject.send(url) { (_, _, _) -> Void in }
    
    XCTAssert(session.lastURL === url)
  }
  
  func test_Send_StartsTheRequest() {
    let dataTask = MockURLSessionDataTask()
    session.nextDataTask = dataTask
    
    subject.send(NSURL()) { (_, _, _) -> Void in }
    
    XCTAssert(dataTask.resumeWasCalled)
  }
  
  func test_Send_WithResponseData_ReturnsTheData() {
    let expectedData = "{}".dataUsingEncoding(NSUTF8StringEncoding)
    session.nextData = expectedData
    
    var actualData: NSData?
    subject.send(NSURL()) { (data, _, _) -> Void in
      actualData = data
    }
    
    XCTAssertEqual(actualData, expectedData)
  }
  
  func test_Send_WithANetworkError_ReturnsANetworkError() {
    session.nextError = NSError(domain: "error", code: 0, userInfo: nil)
    
    var error: ErrorType?
    subject.send(NSURL()) { (_, _, theError) -> Void in
      error = theError
    }
    
    XCTAssertNotNil(error)
  }
}
