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
public protocol YelpResponse {
  
  /// If the response was recieved without an error
  var wasSuccessful: Bool { get }
  
  /// The request that was sent to generate this response
  var request: YelpRequest { get }
  
  /// Suggested bounds in a map to display results in
  var region: YelpRegion? { get }
  
  /// Total number of business results
  var total: Int? { get }
  
  /// An array containing the businesses that were in the response, or an empty array if there was an error
  var businesses: [YelpBusiness]? { get }
  
  /// The error recieved in the response, or nil if there was no error
  var error: YelpResponseError? { get }
}

extension YelpResponse {
  public var wasSuccessful: Bool {
    return self.error == nil
  }
}
