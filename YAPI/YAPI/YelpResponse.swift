//
//  YelpResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/27/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public protocol YelpResponse {
  init(withJSON data: [String: AnyObject]) throws

  /// If the response was recieved without an error
  var wasSuccessful: Bool { get }
  
  /// The error recieved in the response, or nil if there was no error
  var error: YelpResponseError? { get }
}

extension YelpResponse {
  public var wasSuccessful: Bool {
    return error == nil
  }
}
