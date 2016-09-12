//
//  YelpBusinessResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpBusinessResponse : YelpResponse {
  public let request: YelpRequest
  public let region: YelpRegion? = nil
  public let total: Int? = nil
  public let businesses: [YelpBusiness]?
  public let error: YelpResponseError?
  
  init(withJSON data: [String: AnyObject], from request: YelpRequest) {
    if let error = data["error"] as? [String: AnyObject] {
      switch error["id"] as! String {
      case "INTERNAL_ERROR":
        self.error = YelpResponseError.InternalError
      case "EXCEEDED_REQS":
        self.error = YelpResponseError.ExceededRequests
      case "MISSING_PARAMETER":
        self.error = YelpResponseError.MissingParameter(field: error["field"] as! String)
      case "INVALID_PARAMETER":
        self.error = YelpResponseError.InvalidParameter(field: error["field"] as! String)
      case "UNAVAILABLE_FOR_LOCATION":
        self.error = YelpResponseError.UnavailableForLocation
      case "AREA_TOO_LARGE":
        self.error = YelpResponseError.AreaTooLarge
      case "MULTIPLE_LOCATIONS":
        self.error = YelpResponseError.MultipleLocations
      case "BUSINESS_UNAVAILABLE":
        self.error = YelpResponseError.BusinessUnavailable
      default:
        self.error = YelpResponseError.UnknownError
      }
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
    self.request = request
  }
}