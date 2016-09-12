//
//  YelpLocaleParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

/**
    Optional locale parameters. Results will be localized in the region format and
    language if supported. Both countryCode and language should be specified for proper localization.
 */
public struct YelpLocaleParameters {
  enum CountryCode : String {
    case unitedStates = "US"
    case unitedKingdom = "GB"
    case canada = "CA"
  }
  
  enum Language : String {
    case english = "en"
  }
  
  struct FilterLanguage : YelpBooleanParameter {
    let internalValue: Bool
  }
  
  /// ISO 3166-1 alpha-2 country code. Default country to use when parsing the location field.
  var countryCode: CountryCode?
  
  /// ISO 639 language code. Reviews and snippets written in the specified language will be shown.
  var language: Language?
  
  /// Whether to filter business reviews by the specified lang
  var filterLanguage: FilterLanguage?
}

extension YelpLocaleParameters.CountryCode : YelpParameter {
  var key: String {
    return "cc"
  }
  
  var value: String {
    return self.rawValue
  }
}

extension YelpLocaleParameters.Language : YelpParameter {
  var key: String {
    return "lang"
  }
  
  var value: String {
    return self.rawValue
  }
}

extension YelpLocaleParameters.FilterLanguage : YelpParameter {
  var key: String {
    return "lang_filter"
  }
}

extension YelpLocaleParameters.FilterLanguage : BooleanLiteralConvertible {
  init(booleanLiteral value: BooleanLiteralType) {
    internalValue = value
  }
}