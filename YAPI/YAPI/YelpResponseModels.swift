//
//  YelpResponseModels.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/24/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

/**
    A class encapsulating the data recieved in a response from the Yelp api. This will be generated in the 
    completion handler of network calls, and should be created through the YelpAPIFactory class, not 
    through its initializers.
 
    - Usage:
    ```
      // Given some YelpResponse
      
      // Make sure there was no error
      if yelpResponse.wasSuccessful { // Or if yelpResponse.error == nil {
        for business in yelpResponse.businesses {
          // Do stuff with each business...
        }
      }
    ```
 */
public final class YelpResponse {
  
  /// If the response was recieved without an error
  var wasSuccessful: Bool {
      return self.error == nil
  }
  
  /// The request that was sent to generate this response
  let request: YelpRequest
  
  /// An array containing the businesses that were in the response, or an empty array if there was an error
  let businesses: [YelpBusiness]
  
  /// The error recieved in the response, or nil if there was no error
  let error: YelpResponseError?
  
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
    
    var businesses = [YelpBusiness]()
    if self.error == nil {
      for business in data["businesses"] as! [[String: AnyObject]] {
        let yelpBusiness = YelpBusiness(withDict: business)
        businesses.append(yelpBusiness)
      }
    }
    self.businesses = businesses
    self.request = request
  }
}

