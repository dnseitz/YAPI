//
//  YelpCategoryList.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 8/27/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

/**
    Used to access the different categories available to the Yelp API. The default categories given by Yelp 
    can be accessed through the singleton property of the struct.
 */
struct YelpCategoryList {
  /// Singleton object used to access the categories available to the Yelp API
  static let sharedInstance = YelpCategoryList()!
 
  private let categories: [String: [YelpCategoryWrapper]]
  
  init?(file: String = "categories", bundle: NSBundle = NSBundle.mainBundle()) {
    let path = bundle.pathForResource(file, ofType: "json")
    guard let data = NSData(contentsOfFile: path!) else { return nil }
    
    guard let categories = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [[String: AnyObject]] else { return nil }
    
    var yelpCategories = [String: [YelpCategoryWrapper]](minimumCapacity: 26)
    for category in categories {
      let yelpCategory = YelpCategoryWrapper(json: category)
      if let allowedCountries = yelpCategory.whitelist {
        if !allowedCountries.contains("US") {
          continue
        }
      }
      
      let key = yelpCategory.key()
      if yelpCategories[key] == nil {
        yelpCategories[key] = [YelpCategoryWrapper](arrayLiteral: yelpCategory)
      }
      else {
        yelpCategories[key]!.append(yelpCategory)
      }
    }
    
    self.categories = yelpCategories
  }
  
  init(categories: [String: [YelpCategory]]) {
    var yelpCategories = [String: [YelpCategoryWrapper]](minimumCapacity: categories.count)
    for (key, category) in categories {
      yelpCategories[key] = category.map { YelpCategoryWrapper(category: $0) }
    }
    
    self.categories = yelpCategories
  }
  
  /**
      Get an array of YelpCategories who's names are prefixed by the argument string.
   
      - Parameter prefix: The prefix to search for
   
      - Returns: An array of YelpCategories that start with the given prefix
   */
  func categoriesBeginning(with prefix: String) -> [YelpCategory] {
    guard let yelpCategories = self.categories[prefix[0].uppercaseString] else { return [YelpCategory]() }
    
    return yelpCategories.filter { $0.category.categoryName.uppercaseString.hasPrefix(prefix.uppercaseString) }.map { $0.category }
  }
  
  /**
      Get the category with the argument name.
   
      - Parameter name: The name of the category to search for
   
      - Returns: The YelpCategory with the given name or nil if none exists
   */
  func category(named name: String) -> YelpCategory? {
    let yelpCategories = self.categoriesBeginning(with: name)
    
    return yelpCategories.filter { $0.categoryName == name }.first
  }
}

private struct YelpCategoryWrapper {
  let category: YelpCategory
  let whitelist: [String]?
  let parents: [String]
  
  init(title: String, alias: String, whitelist: [String]?, parents: [String]) {
    self.category = YelpCategory(withTuple: [title, alias])
    self.whitelist = whitelist
    self.parents = parents
  }
  
  init(category: YelpCategory) {
    self.category = category
    self.whitelist = nil
    self.parents = [String]()
  }
  
  init(json: [String: AnyObject]) {
    let title = json["title"] as! String
    let alias = json["alias"] as! String
    let whitelist = json["country_whitelist"] as? [String]
    let parents = json["parents"] as! [String]
    self.init(title: title, alias: alias, whitelist: whitelist, parents: parents)
  }
  
  func key() -> String {
    return self.category.categoryName[0].uppercaseString
  }
}
