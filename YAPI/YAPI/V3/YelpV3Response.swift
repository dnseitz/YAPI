//
//  YelpV3Response.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public protocol YelpV3Response : YelpResponse {}

extension YelpV3Response {
  static func parse(error dict: [String: AnyObject]) -> YelpResponseError {
    switch dict["code"] as? String {
    case "NOT_FOUND"?:
      return .notFound
    case let error:
      return .unknownError(cause: UnknownErrorCode(code: error))
    }
  }
}
