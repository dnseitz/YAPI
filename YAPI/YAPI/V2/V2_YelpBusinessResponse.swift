//
//  YelpBusinessResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpV2BusinessResponse : YelpV2Response {
  public let region: YelpRegion? = nil
  public let total: Int? = nil
  public let businesses: [YelpBusiness]?
  public let error: YelpResponseError?
  
  public init(withJSON data: [String: AnyObject]) {
    if let error = data["error"] as? [String: AnyObject] {
      self.error = YelpV2BusinessResponse.parseError(errorDict: error)
    }
    else {
      self.error = nil
    }
    
    if self.error == nil {
      let business = YelpBusiness(withDict: data)
      self.businesses = [business]
    }
    else {
      self.businesses = nil
    }
  }
}
