//
//  YelpInterfaceModel.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/22/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation
import OAuthSwift

internal let yelpHost: String = "api.yelp.com"

internal enum YelpEndpoints {
  internal enum V2 {
    static let search: String = "/v2/search/"
    static let business: String = "/v2/business/"
    static let phone: String = "/v2/phone_search/"
  }
  
  internal enum V3 {
    static let token: String = "/oauth2/token/"
    static let search: String = "/v3/businesses/search/"
  }
}

/**
    Any request that can be sent to the Yelp API conforms to this protocol. This could include requests to 
    the search API, business API, etc. The sendRequest function will query the Yelp API and return either a 
    response or an error.
 
    - Usage:
    ```
      // Given some YelpRequest
 
      // Send the request and handle the response
      yelpRequest.send() { (response, error) in
        // Handle response or error
      }
    ```
 */
public protocol YelpRequest {
  associatedtype Response: YelpResponse
  
  /// The hostname of the yelp endpoint
  var host: String { get }
  
  /// The path to the yelp api
  var path: String { get }
  
  /// Query parameters to include in the request
  var parameters: [String: String] { get }
  
  /// The HTTP Method used for this request
  var requestMethod: OAuthSwiftHTTPRequest.Method { get }
  
  /// The http session used to send this request
  var session: YelpHTTPClient { get }
  
  /**
   Sends the request, calling the given handler with either the yelp response or an error. This can be
   called multiple times to retry sending the request
   
   - Parameter completionHandler: The block to call when the response returns, takes a YelpResponse? and
   a YelpError? as arguments, the error can be of YelpResponseError type or YelpRequestError type
   */
  func send(completionHandler handler: @escaping (_ response: Self.Response?, _ error: YelpError?) -> Void)
}

public extension YelpRequest {
  var host: String {
    return yelpHost
  }

  public func send(completionHandler handler: @escaping (_ response: Self.Response?, _ error: YelpError?) -> Void) {
    guard let urlRequest = self.generateURLRequest() else {
      handler(nil, YelpRequestError.failedToGenerateRequest)
      return
    }
    
    self.session.send(urlRequest) {(data, response, error) in
      let finalResponse: Self.Response?
      let finalError: YelpError?
      defer {
        DispatchQueue.main.async {
          handler(finalResponse, finalError)
        }
      }
      
      if let err = error {
        finalResponse = nil
        finalError = YelpRequestError.failedToSendRequest(err as NSError)
        return
      }
      
      guard let jsonData = data else {
        finalResponse = nil
        finalError = YelpResponseError.noDataRecieved
        return
      }
      
      let responseResult = YelpAPIFactory.makeResponse(with: jsonData, from: self)//self.makeResponse(with: jsonData)
      
      guard case .ok(let yelpResponse) = responseResult else {
        finalResponse = nil
        finalError = YelpResponseError.failedToParse(cause: responseResult.unwrapErr())
        return
      }
      
      if yelpResponse.wasSuccessful {
        finalResponse = yelpResponse
        finalError = nil
      }
      else {
        finalResponse = yelpResponse
        finalError = yelpResponse.error
      }
    }
  }
}

fileprivate extension YelpRequest {
  func generateURLRequest() -> URLRequest? {
    guard let consumerKey = AuthKeys.consumerKey, let consumerSecret = AuthKeys.consumerSecret, let token = AuthKeys.token, let tokenSecret = AuthKeys.tokenSecret else {
      assert(false, "The request requires a consumerKey, consumerSecret, token, and tokenSecret in order to access the Yelp API, set these through the YelpAPIFactory")
      return nil
    }
    let oauth = OAuthSwiftClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: token, accessTokenSecret: tokenSecret)
    
    guard let request = oauth.makeRequest("https://\(self.host)\(self.path)", method: self.requestMethod, parameters: self.parameters, headers: nil, body: nil) else { return nil }
    
    return try? request.makeRequest()
  }
}
