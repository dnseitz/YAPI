//
//  YelpPhoneSearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/12/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV2PhoneSearchParameters {
  public struct Phone : YelpStringParameter {
    let internalValue: String
    
    public var key: String {
      return "phone"
    }
  }
  
  public struct Category : YelpStringParameter {
    var internalValue: String
    
    public var key: String {
      return "category"
    }
  }
  
  /// Parameter that specifies the business phone number to search for. Outside of the US and Canada, include the international dialing code (e.g. +442079460000) or use the `countryCode` parameter
  var phone: Phone
  
  /// ISO 3166-1 alpha-2 country code. Default country to use when parsing the phone number.
  var countryCode: YelpCountryCodeParameter?
  
  /// Category to filter search results with.
  var category: Category?
  
  init(phone: Phone, countryCode: YelpCountryCodeParameter? = nil, category: Category? = nil) {
    self.phone = phone
    self.countryCode = countryCode
    self.category = category
  }
}

extension YelpV2PhoneSearchParameters.Phone : ExpressibleByStringLiteral {
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

extension YelpV2PhoneSearchParameters.Category : ExpressibleByStringLiteral {
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
