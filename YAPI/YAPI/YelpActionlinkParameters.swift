//
//  YelpActionlinkParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

/**
    Parameters for including actionable links for actions like Food ordering on Eat24 and booking a table 
    at a restaurant via Seatme
 */
public struct YelpActionlinkParameters {
  struct Actionlinks : YelpBooleanParameter {
    let internalValue: Bool
    
    var key: String {
      return "actionlinks"
    }
    
    init(booleanLiteral value: BooleanLiteralType) {
      self.internalValue = value
    }
  }
  
  /// Whether to include links to actionable content if available
  var actionlinks: Actionlinks?
}

