//
//  YelpV3TokenParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV3TokenParameters {
  public enum GrantType : String, YelpParameter {
    public var key: String {
      return "grant_type"
    }
    
    public var value: String {
      return self.rawValue
    }
    
    case clientCredentials = "client_credentials"
  }
  
  public struct ClientID : YelpStringParameter {
    let internalValue: String
    
    public var key: String {
      return "client_id"
    }
  }
  
  //public struct ClientSecret
  
  //let grantType:
}

extension YelpV3TokenParameters.ClientID {
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
