//
//  YelpLocaleParametersTests.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpLocaleParametersTests: YAPIXCTestCase {

  func test_ParametersValue_GivesCorrectValue() {
    let parameter = YelpLocaleParameters(countryCode: .unitedStates, language: .english, filterLanguage: false)
    
    XCTAssertNotNil(parameter.countryCode)
    XCTAssertNotNil(parameter.language)
    XCTAssertNotNil(parameter.filterLanguage)
    
    XCTAssert(parameter.countryCode!.value == "US")
    XCTAssert(parameter.language!.value == "en")
    XCTAssert(parameter.filterLanguage!.value == "false")
  }
  
  func test_CountryCode_GivesCorrectKeyValue() {
    let cc = YelpLocaleParameters.CountryCode.canada
    
    XCTAssert(cc.key == "cc")
    XCTAssert(cc.value == "CA")
  }
  
  func test_Language_GivesCorrectKeyValue() {
    let language = YelpLocaleParameters.Language.english
    
    XCTAssert(language.key == "lang")
    XCTAssert(language.value == "en")
  }
  
  func test_FilterLanguage_GivesCorrectKeyValue() {
    let filter = YelpLocaleParameters.FilterLanguage(booleanLiteral: true)
    
    XCTAssert(filter.key == "lang_filter")
    XCTAssert(filter.value == "true")
  }
  
}
