//
//  YelpSearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift
import CoreLocation

/**
    A YelpRequest that queries the Yelp API's search service. This gives a list of businesses based on 
    certain parameters like category, type, distance, search location, etc. The number of businesses 
    returned can be limited as well in the parameters. This class is meant to be one-shot, if you want to 
    send another request create a new instance of this class. The query parameters can only be set in the 
    initializer. Instances of this class should be created through the YelpAPIFactory.
 */
public final class YelpSearchRequest: YelpRequest {
  
  /// The hostname of the yelp endpoint
  public let host: String = yelpHost
  
  /// The path to the yelp api
  public let path: String = searchEndpoint
  
  /// Query parameters to include in the request
  public let parameters: [String: String]
  
  /// The http session used to send this request
  public let session: YelpHTTPClient
  
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  
  private var sendable: Bool {
    return (self.parameters["location"] != nil || self.parameters["ll"] != nil)
  }
  
  init(withLocation location: String? = nil,
          currentLocation cl: CLLocation? = nil,
             withLimit limit: Int? = nil,
               withTerm term: YelpSearchTerm? = nil,
           withOffset offset: Int? = nil,
                 sortBy sort: YelpSortMode? = nil,
       withCategory category: [String]? = nil,
   withRadiusInMeters radius: Int? = nil,
     filterDeals dealsFilter: Bool? = nil,
         withSession session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    
    assert(location != nil || cl != nil, "Must have some way of determining location")
    
    var parameters = [String: String]()
    if let location = location {
      parameters["location"] = location
      if let cl = cl {
        parameters["cl"] = "\(cl.coordinate.latitude),\(cl.coordinate.longitude)"
      }
    }
    else if let cl = cl {
      parameters["ll"] = "\(cl.coordinate.latitude),\(cl.coordinate.longitude)"
    }
    if let limit = limit {
      parameters["limit"] = String(limit)
    }
    if let term = term {
      parameters["term"] = String(term)
    }
    if let offset = offset {
      parameters["offset"] = String(offset)
    }
    if let sort = sort {
      parameters["sort"] = String(sort.rawValue)
    }
    if let category = category {
      parameters["category_filter"] = category.joinWithSeparator(",")
    }
    if let radius = radius {
      parameters["radius_filter"] = String(radius)
    }
    if let dealsFilter = dealsFilter {
      parameters["deals_filter"] = String(dealsFilter)
    }
    
    self.parameters = parameters
    self.session = session
  }
  
  /**
      Sends the request, calling the given handler with either the yelp response or an error. This can be
      called multiple times to retry sending the request
   
      - Parameter completionHandler: The block to call when the response returns, takes a YelpResponse? and
          a YelpError? as arguments, the error can be of YelpResponseError type or YelpRequestError type
   */
  public func send(completionHandler handler: (response: YelpResponse?, error: YelpError?) -> Void) {
    
    if !self.sendable {
      handler(response: nil, error: YelpRequestError.NoLocationData)
      return
    }
    
    (self as YelpRequest).send(completionHandler: handler)
  }
}