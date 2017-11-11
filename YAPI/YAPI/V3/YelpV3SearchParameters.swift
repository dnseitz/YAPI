//
//  YelpV3SearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV3SearchParameters {
  public struct Term : YelpStringParameter {
    let internalValue: String
    
    public var key: String {
      return "term"
    }
  }
  
  public struct Radius : YelpIntParameter {
    let internalValue: Int
    
    public var key: String {
      return "radius"
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Categories : YelpArrayParameter {
    // TODO: Look at coming back and changing this to some Category type?
    public typealias Element = String
    
    let internalValue: [Element]
    
    public var key: String {
      return "categories"
    }
    
    public init?(_ elements: [Element]?) {
      if let elements = elements {
        self.internalValue = elements
      }
      else {
        return nil
      }
    }
  }
  
  public struct Locale : YelpParameter {
    let internalValue: Language
    
    public var key: String {
      return "locale"
    }
    
    public var value: String {
      return internalValue.rawValue
    }
    
    public init(language value: Language) {
      self.internalValue = value
    }
  }
  
  /// Search term (e.g. "food", "restaurants"). If term isn’t included we search everything. The term keyword also accepts business names such as "Starbucks".
  public let term: Term?
  
  /// Location to search near by
  public let location: YelpV3LocationParameter
  
  /// Search radius in meters. If the value is too large, a AREA_TOO_LARGE error may be returned. The max value is 40000 meters (25 miles).
  public let radius: Radius?
  
  /// Categories to filter the search results with.
  public let categories: Categories?
  
  public let locale: Locale = Locale(language: YelpLocale.English.canada)
  
}

extension YelpV3SearchParameters.Term : ExpressibleByStringLiteral {
  public typealias UnicodeScalarLiteralType = Character
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  
  public init(stringLiteral value: StringLiteralType) {
    self.internalValue = value
  }
  
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.internalValue = "\(value)"
  }
  
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.internalValue = value
  }
}
