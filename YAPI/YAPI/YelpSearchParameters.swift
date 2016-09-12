//
//  YelpSearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpSearchParameters {
  enum SearchTerm : String, YelpParameter {
    var key: String {
      return "term"
    }
    
    var value: String {
      return self.rawValue
    }
    
    case food = "food"
    case drink = "drink"
  }
  
  struct Limit : YelpIntParameter {
    let internalValue: Int
    
    var key: String {
      return "limit"
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  struct Offset : YelpIntParameter {
    let internalValue: Int
    
    var key: String {
      return "offset"
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  enum SortMode : Int, YelpParameter {
    var key: String {
      return "sort"
    }
    
    var value: String {
      return String(self.rawValue)
    }
  
    case best = 0
    case distance = 1
    case highestRated = 2
  }
  
  struct Categories: YelpArrayParameter {
    typealias Element = String
    
    let internalValue: [Element]
    
    var key: String {
      return "category_filter"
    }
    
    init(arrayLiteral elements: Element...) {
      self.internalValue = elements
    }
  }
  
  struct Radius : YelpIntParameter {
    let internalValue: Int
    
    var key: String {
      return "radius_filter"
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  struct Deals : YelpBooleanParameter {
    let internalValue: Bool
    
    var key: String {
      return "deals_filter"
    }
    
    init(booleanLiteral value: BooleanLiteralType) {
      self.internalValue = value
    }
  }
  
  /// The location to search near
  var location: YelpLocationParameter
  
  /// Search term (e.g. "food", "restaurants"). If term isn’t included we search everything. The term keyword also accepts business names such as "Starbucks".
  var term: SearchTerm?
  
  /// Number of business results to return
  var limit: Limit?
  
  /// Offset the list of returned business results by this amount
  var offset: Offset?
  
  /// Sort mode
  var sortMode: SortMode?
  
  /// Category to filter search results with.
  var categories: Categories?
  
  /// Search radius in meters. If the value is too large, a AREA_TOO_LARGE error may be returned. The max value is 40000 meters (25 miles).
  var radius: Radius?
  
  /// Whether to exclusively search for businesses with deals
  var filterDeals: Deals?
  
  init(location: YelpLocationParameter,
           term: SearchTerm? = nil,
          limit: Limit? = nil,
         offset: Offset? = nil,
       sortMode: SortMode? = nil,
     categories: Categories? = nil,
         radius: Radius? = nil,
    filterDeals: Deals? = nil) {
    
    self.location = location
    self.term = term
    self.limit = limit
    self.offset = offset
    self.sortMode = sortMode
    self.categories = categories
    self.radius = radius
    self.filterDeals = filterDeals
  }
}