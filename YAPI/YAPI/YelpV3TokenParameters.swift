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
  
  public struct ClientSecret : YelpStringParameter {
    let internalValue: String
    
    public var key: String {
      return "client_secret"
    }
  }
  
  /// The OAuth2 grant type to use. Right now, only client_credentials is supported.
  public let grantType: GrantType
  
  /// The client id for you app with Yelp.
  public let clientId: ClientID
  
  /// The client secret for you app with Yelp.
  public let clientSecret: ClientSecret
  
  public init(grantType: GrantType, clientId: ClientID, clientSecret: ClientSecret) {
    self.grantType = grantType
    self.clientId = clientId
    self.clientSecret = clientSecret
  }
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

extension YelpV3TokenParameters.ClientSecret {
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
