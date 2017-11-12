//
//  YelpV3TokenResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpV3TokenResponse : YelpV3Response {
  private enum Params {
    static let access_token = "access_token"
    static let token_type = "token_type"
    static let expires_in = "expires_in"
  }
  
  
  public enum TokenType : String {
    case bearer = "Bearer"
  }
  
  public let accessToken: String?
  public let tokenType: TokenType?
  public let expiresIn: Int?
  
  public let error: YelpResponseError?
  public var wasSuccessful: Bool {
    return error == nil
  }
  
  public init(withJSON data: [String: AnyObject]) throws {
    if let error = data["error"] as? [String: AnyObject] {
      self.error = YelpV3TokenResponse.parse(error: error)
    }
    else {
      self.error = nil
    }
    
    if self.error == nil {
      guard let accessToken = data[Params.access_token] as? String else {
        throw YelpParseError.missing(field: Params.access_token)
      }
      guard let rawTokenType = data[Params.token_type] as? String else {
        throw YelpParseError.missing(field: Params.token_type)
      }
      guard let expiresIn = data[Params.expires_in] as? Int else {
        throw YelpParseError.missing(field: Params.expires_in)
      }
      guard let tokenType = TokenType(rawValue: rawTokenType) else {
        throw YelpParseError.invalid(field: Params.token_type, value: rawTokenType)
      }
      self.accessToken = accessToken
      self.tokenType = tokenType
      self.expiresIn = expiresIn
    }
    else {
      self.accessToken = nil
      self.tokenType = nil
      self.expiresIn = nil
    }
  }
}
