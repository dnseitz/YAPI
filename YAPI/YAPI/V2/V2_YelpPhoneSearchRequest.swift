//
//  YelpPhoneSearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/12/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV2PhoneSearchRequest : InternalYelpRequest {
  public typealias Response = YelpV2PhoneSearchResponse
  
  public let path: String = YelpEndpoints.V2.phone
  public let parameters: [String: String]
  public let session: YelpHTTPClient
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  
  init(phoneSearch: YelpV2PhoneSearchParameters, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    var parameters = [String: String]()
    
    parameters.insertParameter(phoneSearch.phone)
    if let countryCode = phoneSearch.countryCode {
      parameters.insertParameter(countryCode)
    }
    if let category = phoneSearch.category {
      parameters.insertParameter(category)
    }
    self.parameters = parameters
    self.session = session
  }
}
