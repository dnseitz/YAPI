//
//  YelpActionlinkParametersTests.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpActionlinkParametersTests: YAPIXCTestCase {
  func test_ParametersValue_GivesCorrectValue() {
    let actionlink = YelpActionlinkParameters(actionlinks: true)
    
    XCTAssertNotNil(actionlink.actionlinks)
    
    XCTAssert(actionlink.actionlinks!.value == "true")
  }
  
  func test_Actionlinks_GivesCorrectKeyValue() {
    let actionlinks = YelpActionlinkParameters.Actionlinks(booleanLiteral: false)
    
    XCTAssert(actionlinks.key == "actionlinks")
    XCTAssert(actionlinks.value == "false")
  }
}
