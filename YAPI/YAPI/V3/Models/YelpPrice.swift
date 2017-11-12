//
//  YelpPrice.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/11/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

public enum YelpPrice: Int {
  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case five = 5
  
  public init?(withDollarSigns string: String) {
    let trimmed = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    guard trimmed.contains(where: { $0 != "$" }) == false else {
      return nil
    }
    
    self.init(rawValue: trimmed.count)
  }
}
