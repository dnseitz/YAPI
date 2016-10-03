//
//  YelpV3TokenResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpV3TokenResponse : YelpV3Response {
  public enum TokenType : String {
    case bearer = "bearer"
  }
  
  public let accessToken: String?
  public let tokenType: TokenType?
  public let expiresIn: Int?
  
  public let error: YelpResponseError?
  public var wasSuccessful: Bool {
    return error == nil
  }
  
  init(withJSON data: [String: AnyObject]) {
    if let error = data["error"] as? [String: AnyObject] {
      self.error = YelpV3TokenResponse.parseError(error: error)
    }
    else {
      self.error = nil
    }
    
    if self.error == nil {
      self.accessToken = (data["access_token"] as! String)
      self.tokenType = TokenType(rawValue: data["token_type"] as! String)!
      self.expiresIn = data["expires_in"] as! Int
    }
    else {
      self.accessToken = nil
      self.tokenType = nil
      self.expiresIn = nil
    }
  }
}
