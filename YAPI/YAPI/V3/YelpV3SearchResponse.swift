//
//  YelpV3SearchResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/11/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpV3SearchResponse: YelpV3Response {
  
  private enum Params {
    static let total = "total"
    static let businesses = "businesses"
    static let region = "region"
  }
  
  public let total: Int
  public let businesses: [YelpV3Business]
  public let region: YelpRegion
  
  public var error: YelpResponseError?
  
  public init(withJSON data: [String : AnyObject]) throws {
    self.total = try data.parseParam(key: Params.total)

    let businesses: [[String: AnyObject]] = try data.parseParam(key: Params.businesses)
    self.businesses = try businesses.map { try YelpV3Business(withDict: $0) }

    let region: [String: AnyObject] = try data.parseParam(key: Params.region)
    self.region = YelpRegion(withDict: region)
  }
}
