//
//  YelpV3Response.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public protocol YelpV3Response : YelpResponse {
  
}

extension YelpV3Response {
  static func parseError(error dict: [String: AnyObject]) -> YelpResponseError {
    return .unknownError
    /*
    switch dict["id"] as? String {
    default:
      return .unknownError
    }
    */
  }
}
