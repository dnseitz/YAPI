//
//  YelpResponseModels.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/24/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

/**
    A protocol encapsulating the data recieved in a response from the Yelp api. This will be generated in 
    the completion handler of network calls, and should be created through the YelpAPIFactory class, not
    through its initializers.
 
    - Usage:
    ```
      // Given some YelpResponse
      
      // Make sure there was no error
      if yelpResponse.wasSuccessful {
        guard let businesses = yelpResponse.businesses else { return }
        for business in businesses {
          // Do stuff with each business...
        }
      }
    ```
 */
public protocol YelpV2Response : YelpResponse {
  /// Suggested bounds in a map to display results in
  var region: YelpRegion? { get }
  
  /// Total number of business results
  var total: Int? { get }
  
  /// An array containing the businesses that were in the response, or an empty array if there was an error
  var businesses: [YelpBusiness]? { get }
  
}

extension YelpV2Response {
  static func parseError(errorDict dict: [String: AnyObject]) -> YelpResponseError {
    switch dict["id"] as? String {
    case "INTERNAL_ERROR"?:
      return YelpResponseError.internalError
    case "EXCEEDED_REQS"?:
      return YelpResponseError.exceededRequests
    case "MISSING_PARAMETER"?:
      return YelpResponseError.missingParameter(field: dict["field"] as! String)
    case "INVALID_PARAMETER"?:
      return YelpResponseError.invalidParameter(field: dict["field"] as! String)
    case "UNAVAILABLE_FOR_LOCATION"?:
      return YelpResponseError.unavailableForLocation
    case "AREA_TOO_LARGE"?:
      return YelpResponseError.areaTooLarge
    case "MULTIPLE_LOCATIONS"?:
      return YelpResponseError.multipleLocations
    case "BUSINESS_UNAVAILABLE"?:
      return YelpResponseError.businessUnavailable
    case let error:
      return YelpResponseError.unknownError(cause: UnknownErrorCode(code: error))
    }
  }
  
  public var wasSuccessful: Bool {
    return self.error == nil
  }
}
