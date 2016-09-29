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
public struct YelpV2LocaleParameters {
  enum LanguageParameter : String {
    case english = "en"
  }
  
  struct FilterLanguageParameter : YelpBooleanParameter {
    let internalValue: Bool
    
    var key: String {
      return "lang_filter"
    }
    
    init(booleanLiteral value: BooleanLiteralType) {
      internalValue = value
    }
  }
  
  /// ISO 3166-1 alpha-2 country code. Default country to use when parsing the location field.
  var countryCode: YelpCountryCodeParameter?
  
  /// ISO 639 language code. Reviews and snippets written in the specified language will be shown.
  var language: LanguageParameter?
  
  /// Whether to filter business reviews by the specified lang
  var filterLanguage: FilterLanguageParameter?
}


extension YelpV2LocaleParameters.LanguageParameter : YelpParameter {
  var key: String {
    return "lang"
  }
  
  var value: String {
    return self.rawValue
  }
}
