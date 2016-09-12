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
internal let searchEndpoint: String = "/v2/search/"
internal let businessEndpoint: String = "/v2/business/"
internal let phoneEndpoint: String = "/v2/phone_search/"

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
}

public extension YelpRequest {
  var host: String {
    return yelpHost
  }
  
  /**
      Sends the request, calling the given handler with either the yelp response or an error. This can be
      called multiple times to retry sending the request
   
      - Parameter completionHandler: The block to call when the response returns, takes a YelpResponse? and
          a YelpError? as arguments, the error can be of YelpResponseError type or YelpRequestError type
   */
  func send(completionHandler handler: (response: YelpResponse?, error: YelpError?) -> Void) {
    guard let urlRequest = self.generateURLRequest() else {
      handler(response: nil, error: YelpRequestError.FailedToGenerateRequest)
      return
    }
    
    self.session.send(urlRequest) {(data, response, error) in
      let finalResponse: YelpResponse?
      let finalError: YelpError?
      defer {
        GlobalMainQueue.executeAsync() {
          handler(response: finalResponse, error: finalError)
        }
      }
      
      if let err = error {
        finalResponse = nil
        finalError = YelpRequestError.FailedToSendRequest(err)
        return
      }
      
      guard let jsonData = data else {
        finalResponse = nil
        finalError = YelpResponseError.NoDataRecieved
        return
      }
      
      let optionalYelpResponse = YelpAPIFactory.makeResponse(with: jsonData, from: self)
      
      guard let yelpResponse = optionalYelpResponse else {
        finalResponse = nil
        finalError = YelpResponseError.FailedToParse
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

extension YelpRequest {
  func generateURLRequest() -> NSURLRequest? {
    guard let consumerKey = AuthKeys.consumerKey, consumerSecret = AuthKeys.consumerSecret, token = AuthKeys.token, tokenSecret = AuthKeys.tokenSecret else {
      assert(false, "The request requires a consumerKey, consumerSecret, token, and tokenSecret in order to access the Yelp API, set these through the YelpAPIFactory")
      return nil
    }
    let oauth = OAuthSwiftClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: token, accessTokenSecret: tokenSecret)
    
    guard let request = oauth.makeRequest("https://\(self.host)\(self.path)", method: self.requestMethod, parameters: self.parameters, headers: nil, body: nil) else { return nil }
    
    return try? request.makeRequest()
  }
}

