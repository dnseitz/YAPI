//
//  YelpAPIFactory.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/25/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

/**
    Factory class that generates Yelp requests and responses for use.
 */
public enum YelpAPIFactory {
  /**
      Set the authentication keys that will be used to generate requests. These keys are needed in order 
      for the Yelp API to successfully authenticate your requests, if you generate a request without these 
      set the request will fail to send
   
      - Parameters:
        - consumerKey: The OAuth consumer key
        - consumerSecret: The OAuth consumer secret
        - token: The OAuth token
        - tokenSecret: The OAuth token secret
   */
  public static func setAuthenticationKeys(consumerKey: String,
                                        consumerSecret: String,
                                                 token: String,
                                           tokenSecret: String) {
    AuthKeys.consumerKey = consumerKey
    AuthKeys.consumerSecret = consumerSecret
    AuthKeys.token = token
    AuthKeys.tokenSecret = tokenSecret
  }
  
  
  /**
      Build a request with the specified parameters, useful for fine tuning of parameters being sent.
      Recommend using the request(withRequestParams:) function instead with the DataManager's request
      parameters in most cases
   
      - Parameters:
        - location: A string indicating some location, usually a city
        - limit: The number of businesses to return in the result
        - term: The type that this request should be searching (i.e. food)
        - offset: The number of top businesses to skip over
        - sort: The sort mode, see YelpSortMode for values
        - category: A string indicating a category to search
        - radius: Radius to search around in meters
        - dealsFilter: Boolean value indicating whether businesses with deals should be filtered
   
      - Returns: A fully formed request that can be sent immediately
   
   */
  public static func makeSearchRequest(withLocation location: String? = nil,
                                             currentLocation: CLLocation? = nil,
                                             withLimit limit: Int? = nil,
                                               withTerm term: YelpSearchTerm? = nil,
                                           withOffset offset: Int? = nil,
                                                 sortBy sort: YelpSortMode? = nil,
                                       withCategory category: [String]? = nil,
                                   withRadiusInMeters radius: Int? = nil,
                                     filterDeals dealsFilter: Bool? = nil) -> YelpSearchRequest {
    
    return YelpSearchRequest(withLocation: location,
                          currentLocation: currentLocation,
                                withLimit: limit,
                                 withTerm: term,
                               withOffset: offset,
                                   sortBy: sort,
                             withCategory: category,
                       withRadiusInMeters: radius,
                              filterDeals: dealsFilter)
  }
  
  /**
      Build a request with the specified request parameters, use this in conjunction with the 
      DataManager's request parameters property in most cases
   
      - Parameter params: A struct containing information with which to create a request
   
      - Returns: A fully formed request that can be sent immediately
   */
  public static func makeSearchRequest(with parameters: YelpSearchParameters) -> YelpSearchRequest {
    
    return YelpSearchRequest(withLocation: parameters.location,
                          currentLocation: parameters.currentLocation,
                                withLimit: parameters.limit,
                                 withTerm: parameters.term,
                               withOffset: parameters.offset,
                                   sortBy: parameters.sortMode,
                             withCategory: parameters.category,
                       withRadiusInMeters: parameters.radius,
                              filterDeals: parameters.filterDeals)
  }
  
  /**
      Build a response from the JSON body recieved from making a request.
   
      - Parameter json: A dictionary containing the JSON body recieved in the Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, populated with businesses or an error
   */
  static func makeResponse(withJSON json: [String: AnyObject], from request: YelpRequest) -> YelpResponse {
    return YelpResponse(withJSON: json, from: request)
  }
  
  /**
      Build a response from the still encoded body recieved from making a request.
   
      - Parameter data: An NSData object of the data recieved from a Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, or nil if the data cannot be parsed
   */
  static func makeResponse(with data: NSData, from request: YelpRequest) -> YelpResponse? {
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
      return YelpResponse(withJSON: json as! [String: AnyObject], from: request)
    }
    catch {
      return nil
    }
  }
  
}