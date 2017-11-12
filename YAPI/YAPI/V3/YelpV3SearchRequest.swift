//
//  YelpV3SearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV3SearchRequest : YelpRequest {
  public typealias Response = YelpV3SearchResponse
 
  public let oauthVersion: OAuthSwiftCredential.Version = .oauth2
  public let path: String = YelpEndpoints.V3.search
  public let parameters: [String : String]
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  public let session: YelpHTTPClient
  
  init(searchParameters: YelpV3SearchParameters, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    var parameters = [String: String]()
    parameters.insertParameter(searchParameters.term)
    parameters.insertParameter(searchParameters.location.location)
    parameters.insertParameter(searchParameters.location.latitude)
    parameters.insertParameter(searchParameters.location.longitude)
    parameters.insertParameter(searchParameters.radius)
    parameters.insertParameter(searchParameters.categories)
    parameters.insertParameter(searchParameters.locale)
    parameters.insertParameter(searchParameters.limit)
    parameters.insertParameter(searchParameters.offset)
    parameters.insertParameter(searchParameters.sortMode)
    parameters.insertParameter(searchParameters.price)
    parameters.insertParameter(searchParameters.openNow)
    parameters.insertParameter(searchParameters.openAt)
    parameters.insertParameter(searchParameters.attributes)
    
    self.parameters = parameters
    self.session = session
  }
  
}

