//
//  YelpSearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV2SearchParameters {
  public enum SearchTerm : String, YelpParameter {
    public var key: String {
      return "term"
    }
    
    public var value: String {
      return self.rawValue
    }
    
    case food = "food"
    case drink = "drink"
  }
  
  public struct Limit : YelpIntParameter {
    let internalValue: Int
    
    public var key: String {
      return "limit"
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Offset : YelpIntParameter {
    let internalValue: Int
    
    public var key: String {
      return "offset"
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public enum SortMode : Int, YelpParameter {
    public var key: String {
      return "sort"
    }
    
    public var value: String {
      return String(self.rawValue)
    }
  
    case best = 0
    case distance = 1
    case highestRated = 2
  }
  
  public struct Categories : YelpArrayParameter {
    public typealias Element = String
    
    let internalValue: [Element]
    
    public var key: String {
      return "category_filter"
    }
    
    public init?(_ elements: [Element]?) {
      if let elements = elements {
        self.internalValue = elements
      }
      else {
        return nil
      }
    }
  }
  
  public struct Radius : YelpIntParameter {
    let internalValue: Int
    
    public var key: String {
      return "radius_filter"
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Deals : YelpBooleanParameter {
    let internalValue: Bool
    
    public var key: String {
      return "deals_filter"
    }
    
    public init(booleanLiteral value: BooleanLiteralType) {
      self.internalValue = value
    }
  }
  
  /// The location to search near
  public var location: YelpLocationParameter
  
  /// Search term (e.g. "food", "restaurants"). If term isn’t included we search everything. The term keyword also accepts business names such as "Starbucks".
  public var term: SearchTerm?
  
  /// Number of business results to return
  public var limit: Limit?
  
  /// Offset the list of returned business results by this amount
  public var offset: Offset?
  
  /// Sort mode
  public var sortMode: SortMode?
  
  /// Category to filter search results with.
  public var categories: Categories?
  
  /// Search radius in meters. If the value is too large, a AREA_TOO_LARGE error may be returned. The max value is 40000 meters (25 miles).
  public var radius: Radius?
  
  /// Whether to exclusively search for businesses with deals
  public var filterDeals: Deals?
  
  public init(location: YelpLocationParameter,
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
