//
//  CommonParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/12/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

enum YelpCountryCodeParameter : String {
  case unitedStates = "US"
  case unitedKingdom = "GB"
  case canada = "CA"
}

extension YelpCountryCodeParameter : YelpParameter {
  var key: String {
    return "cc"
  }
  
  var value: String {
    return self.rawValue
  }
}
