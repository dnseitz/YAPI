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
  
  public enum V2 {
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

    /// The parameters to use when determining localization
    public static var localeParameters: YelpV2LocaleParameters?
    
    /// The parameters to use to determine whether to show action links
    public static var actionlinkParameters: YelpV2ActionlinkParameters?
    
    /**
        Build a search request with the specified request parameters
     
        - Parameter parameters: A struct containing information with which to create a request
     
        - Returns: A fully formed request that can be sent immediately
     */
    public static func makeSearchRequest(with parameters: YelpV2SearchParameters) -> YelpV2SearchRequest {
      return YelpV2SearchRequest(search: parameters, locale: self.localeParameters, actionlink: self.actionlinkParameters)
    }
    
    /**
        Build a business request searching for the specified businessId
     
        - Parameter businessId: The Yelp businessId to search for
     
        - Returns: A fully formed request that can be sent immediately
     */
    public static func makeBusinessRequest(with businessId: String) -> YelpV2BusinessRequest {
      return YelpV2BusinessRequest(businessId: businessId, locale: self.localeParameters, actionlink: self.actionlinkParameters)
    }
    
    /**
        Build a phone search request searching for a business with a certain phone number
     
        - Parameter parameters: A struct containing information with which to create a request
     
        - Returns: A fully formed request that can be sent immediately
     */
    public static func makePhoneSearchRequest(with parameters: YelpV2PhoneSearchParameters) -> YelpV2PhoneSearchRequest {
      return YelpV2PhoneSearchRequest(phoneSearch: parameters)
    }
  }
  
  public enum V3 {
    public static func authenticate(appId: String,
                                    clientSecret: String,
                                    completionBlock: @escaping (_ error: YelpError?) -> Void) {
      AuthKeys.consumerKey = appId
      AuthKeys.consumerSecret = clientSecret
      
      let clientId = YelpV3TokenParameters.ClientID(internalValue: appId)
      let clientSecret = YelpV3TokenParameters.ClientSecret(internalValue: clientSecret)
      
      let request = makeTokenRequest(with: YelpV3TokenParameters(grantType: .clientCredentials,
                                                                 clientId: clientId,
                                                                 clientSecret: clientSecret))
      
      request.send { result in
        switch result {
        case .ok(let response):
          AuthKeys.token = response.accessToken
          completionBlock(response.error)
        case .err(let error):
          completionBlock(error)
        }
      }
    }

    private static func makeTokenRequest(with parameters: YelpV3TokenParameters) -> YelpV3TokenRequest {
      return YelpV3TokenRequest(token: parameters)
    }
    
    public static func makeSearchRequest(with parameters: YelpV3SearchParameters) -> YelpV3SearchRequest {
      return YelpV3SearchRequest(searchParameters: parameters)
    }
  }
  
  /**
      Build a response from the JSON body recieved from making a request.
   
      - Parameter json: A dictionary containing the JSON body recieved in the Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, populated with businesses or an error
   */
  static func makeResponse<T: YelpRequest>(withJSON json: [String: AnyObject], from request: T) -> Result<T.Response, YelpError> {
    do {
      return try .ok(T.Response.init(withJSON: json))
    }
    catch let error as YelpParseError {
      return .err(YelpResponseError.failedToParse(cause: error))
    }
    catch let error as YelpError {
      return .err(error)
    }
    catch {
      return .err(YelpResponseError.unknownError(cause: error))
    }
  }
  
  /**
      Build a response from the still encoded body recieved from making a request.
   
      - Parameter data: An NSData object of the data recieved from a Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, or nil if the data cannot be parsed
   */
  static func makeResponse<T: YelpRequest>(with data: Data, from request: T) -> Result<T.Response, YelpError> {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
      return YelpAPIFactory.makeResponse(withJSON: json as! [String: AnyObject], from: request)
    }
    catch {
      return .err(YelpResponseError.failedToParse(cause: .invalidJson(cause: error)))
    }
  }
  
}
