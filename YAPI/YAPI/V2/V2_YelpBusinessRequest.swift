//
//  YelpBusinessRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV2BusinessRequest : InternalYelpRequest {
  public typealias Response = YelpV2BusinessResponse
  
  public let path: String
  public let parameters: [String : String]
  public let session: YelpHTTPClient
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  
  init(businessId: String, locale: YelpV2LocaleParameters? = nil, actionlink: YelpV2ActionlinkParameters? = nil, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    var parameters = [String: String]()
    
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
    
    self.path = YelpEndpoints.V2.business + businessId
    self.parameters = parameters
    self.session = session
  }
}
