//
//  YAPIXCTestCase.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YAPIXCTestCase : XCTestCase {
  
  override class func setUp() {
    super.setUp()
    
    YelpAPIFactory.setAuthenticationKeys("", consumerSecret: "", token: "", tokenSecret: "")
    Asserts.shouldAssert = false
  }
  
  override class func tearDown() {
    AuthKeys.clearAuthentication()
    
    super.tearDown()
  }
  
  func dictFromBase64(base64String: String) throws -> [String: AnyObject] {
    let base64Data = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0))
    let json = try NSJSONSerialization.JSONObjectWithData(base64Data!, options: .AllowFragments)
    return json as! [String: AnyObject]
  }
}
