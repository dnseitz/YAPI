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
public final class YelpV2SearchRequest: YelpRequest {
  
  public typealias Response = YelpV2SearchResponse
  
  public let oauthVersion: OAuthSwiftCredential.Version = .oauth1
  public let path: String = YelpEndpoints.V2.search
  public let parameters: [String: String]
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  public let session: YelpHTTPClient
  
  init(search: YelpV2SearchParameters, locale: YelpV2LocaleParameters? = nil, actionlink: YelpV2ActionlinkParameters? = nil, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    var parameters = [String: String]()
    
    // Search Parameters
    parameters.insertParameter(search.location)
    if let hint = (search.location as? InternalLocation)?.hint {
      parameters.insertParameter(hint)
    }
    if let limit = search.limit {
      parameters.insertParameter(limit)
    }
    if let term = search.term {
      parameters.insertParameter(term)
    }
    if let offset = search.offset {
      parameters.insertParameter(offset)
    }
    if let sortMode = search.sortMode {
      parameters.insertParameter(sortMode)
    }
    if let categories = search.categories {
      parameters.insertParameter(categories)
    }
    if let radius = search.radius {
      parameters.insertParameter(radius)
    }
    if let filterDeals = search.filterDeals {
      parameters.insertParameter(filterDeals)
    }
    
    // Locale Parameters
    if let locale = locale {
      if let countryCode = locale.countryCode {
        parameters.insertParameter(countryCode)
      }
      if let language = locale.language {
        parameters.insertParameter(language)
      }
      if let filterLanguage = locale.filterLanguage {
        parameters.insertParameter(filterLanguage)
      }
    }
    
    // Actionlink Parameters
    if let actionlink = actionlink {
      if let actionlinks = actionlink.actionlinks {
        parameters.insertParameter(actionlinks)
      }
    }
    
    self.parameters = parameters
    self.session = session
  }
}
