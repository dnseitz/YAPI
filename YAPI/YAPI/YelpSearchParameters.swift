//
//  YelpSearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpSearchParameters {
  enum SearchTermParameter : String, YelpParameter {
    var key: String {
      return "term"
    }
    
    var value: String {
      return self.rawValue
    }
    
    case food = "food"
    case drink = "drink"
  }
  
  struct LimitParameter : YelpIntParameter {
    let internalValue: Int
    
    var key: String {
      return "limit"
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  struct OffsetParameter : YelpIntParameter {
    let internalValue: Int
    
    var key: String {
      return "offset"
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  enum SortModeParameter : Int, YelpParameter {
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
  
  struct CategoriesParameter : YelpArrayParameter {
    typealias Element = String
    
    let internalValue: [Element]
    
    var key: String {
      return "category_filter"
    }
    
    init(arrayLiteral elements: Element...) {
      self.internalValue = elements
    }
  }
  
  struct RadiusParameter : YelpIntParameter {
    let internalValue: Int
    
    var key: String {
      return "radius_filter"
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  struct DealsParameter : YelpBooleanParameter {
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
  var term: SearchTermParameter?
  
  /// Number of business results to return
  var limit: LimitParameter?
  
  /// Offset the list of returned business results by this amount
  var offset: OffsetParameter?
  
  /// Sort mode
  var sortMode: SortModeParameter?
  
  /// Category to filter search results with.
  var categories: CategoriesParameter?
  
  /// Search radius in meters. If the value is too large, a AREA_TOO_LARGE error may be returned. The max value is 40000 meters (25 miles).
  var radius: RadiusParameter?
  
  /// Whether to exclusively search for businesses with deals
  var filterDeals: DealsParameter?
  
  init(location: YelpLocationParameter,
           term: SearchTermParameter? = nil,
          limit: LimitParameter? = nil,
         offset: OffsetParameter? = nil,
       sortMode: SortModeParameter? = nil,
     categories: CategoriesParameter? = nil,
         radius: RadiusParameter? = nil,
    filterDeals: DealsParameter? = nil) {
    
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