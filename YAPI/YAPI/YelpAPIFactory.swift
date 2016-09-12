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
  /// The parameters to use when determining localization
  public static var localeParameters: YelpLocaleParameters?
  
  /// The parameters to use to determine whether to show action links
  public static var actionlinkParameters: YelpActionlinkParameters?
  
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
      Build a search request with the specified request parameters
   
      - Parameter parameters: A struct containing information with which to create a request
   
      - Returns: A fully formed request that can be sent immediately
   */
  public static func makeSearchRequest(with parameters: YelpSearchParameters) -> YelpSearchRequest {
    return YelpSearchRequest(search: parameters, locale: self.localeParameters, actionlink: self.actionlinkParameters)
  }
  
  /**
      Build a business request searching for the specified businessId
   
      - Parameter businessId: The Yelp businessId to search for
   
      - Returns: A fully formed request that can be sent immediately
   */
  public static func makeBusinessRequest(with businessId: String) -> YelpBusinessRequest {
    return YelpBusinessRequest(businessId: businessId, locale: self.localeParameters, actionlink: self.actionlinkParameters)
  }
  
  /**
      Build a phone search request searching for a business with a certain phone number
   
      - Parameter parameters: A struct containing information with which to create a request
   
      - Returns: A fully formed request that can be sent immediately
   */
  public static func makePhoneSearchRequest(with parameters: YelpPhoneSearchParameters) -> YelpPhoneSearchRequest {
    return YelpPhoneSearchRequest(phoneSearch: parameters)
  }
  
  /**
      Build a response from the JSON body recieved from making a request.
   
      - Parameter json: A dictionary containing the JSON body recieved in the Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, populated with businesses or an error
   */
  static func makeResponse(withJSON json: [String: AnyObject], from request: YelpRequest) -> YelpResponse! {
    switch request {
    case is YelpSearchRequest:
      return YelpSearchResponse(withJSON: json, from: request)
    case is YelpBusinessRequest:
      return YelpBusinessResponse(withJSON: json, from: request)
    case is YelpPhoneSearchRequest:
      return YelpPhoneSearchResponse(withJSON: json, from: request)
    default:
      // We should never reach here
      assert(false, "Request is not a request?")
      return nil
    }
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
      return YelpAPIFactory.makeResponse(withJSON: json as! [String: AnyObject], from: request)
    }
    catch {
      return nil
    }
  }
  
}