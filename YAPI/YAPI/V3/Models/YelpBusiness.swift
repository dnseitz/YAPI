//
//  YelpBusiness.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/11/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

public struct YelpV3Business {
  
  private enum Params {
    static let categories = "categories"
    static let coordinates = "coordinates"
    static let display_phone = "display_phone"
    static let distance = "distance"
    static let id = "id"
    static let image_url = "image_url"
    static let is_closed = "is_closed"
    static let location = "location"
    static let name = "name"
    static let phone = "phone"
    static let price = "price"
    static let rating = "rating"
    static let review_count = "review_count"
    static let url = "url"
    static let transactions = "transactions"
  }
  
  /// A list of category title and alias pairs associated with this business.
  public let categories: [YelpCategory]

  /// The coordinates of this business.
  public let coordinates: YelpCoordinate
  
  /// Phone number for this business formatted for display
  public let displayPhoneNumber: String?
  
  /// The distance in meters from the search location. This returns meters
  /// regardless of the locale.
  public let distance: Double
  
  /// Yelp ID for business
  public let id: String
  
  /// url of photo for this business
  public let image: ImageReference?
  
  /// Whether business has been (permenantly) closed
  public let closed: Bool
  
  /// Location data for this business
  public let location: YelpV3Location
  
  /// Name of this business
  public let name: String

  /// Phone number for this business
  public let phoneNumber: String?
  
  /// Price level of the business. Value is one of $, $$, $$$ and $$$$.
  public let price: YelpPrice
  
  /// Rating for this business (value ranges from 1, 1.5, ... 4.5, 5).
  public let rating: Double
  
  /// Number of reviews for this business
  public let reviewCount: Int

  /// url for business page on Yelp
  public let url: URL

  /// A list of Yelp transactions that the business is registered for. Current supported values are "pickup", "delivery", and "restaurant_reservation".
  public let transactions: [YelpTransaction]
  
  init(withDict dict: [String: AnyObject]) throws {
    let categories: [[String: AnyObject]] = try dict.parseParam(key: Params.categories)
    self.categories = try categories.map { try YelpCategory(withDict: $0) }
    
    let coordinates: [String: AnyObject] = try dict.parseParam(key: Params.coordinates)
    self.coordinates = try YelpCoordinate(withDict: coordinates)
    
    self.displayPhoneNumber = try? dict.parseParam(key: Params.display_phone)
    self.distance = try dict.parseParam(key: Params.distance)
    self.id = try dict.parseParam(key: Params.id)
    self.image = ImageReference(from: try dict.parseParam(key: Params.image_url))
    self.closed = try dict.parseParam(key: Params.is_closed)
    
    let location: [String: AnyObject] = try dict.parseParam(key: Params.location)
    self.location = try YelpV3Location(withDict: location)
    
    self.name = try dict.parseParam(key: Params.name)
    self.phoneNumber = try dict.parseParam(key: Params.phone)
    
    let rawPrice: String = try dict.parseParam(key: Params.price)
    guard let price = YelpPrice(withDollarSigns: rawPrice) else {
        throw YelpParseError.invalid(field: Params.price, value: rawPrice)
    }
    self.price = price
    self.rating = try dict.parseParam(key: Params.rating)
    self.reviewCount = try dict.parseParam(key: Params.review_count)
    
    let rawUrl: String = try dict.parseParam(key: Params.url)
    guard let url = URL(string: rawUrl) else {
      throw YelpParseError.invalid(field: Params.url, value: rawUrl)
    }
    self.url = url
    
    let transactions: [String] = try dict.parseParam(key: Params.transactions)
    self.transactions = try transactions.map { rawTransaction in
      guard let transaction = YelpTransaction(rawValue: rawTransaction) else {
        throw YelpParseError.invalid(field: Params.transactions, value: rawTransaction)
      }
      return transaction
    }
  }
}

public enum YelpTransaction: String {
  case pickup = "pickup"
  case delivery = "delivery"
  case reservation = "restaurant_reservation"
}

public struct YelpV3Location {
  private enum Params {
    static let address1 = "address1"
    static let address2 = "address2"
    static let address3 = "address3"
    static let city = "city"
    static let country = "country"
    static let display_address = "display_address"
    static let state = "state"
    static let zip_code = "zip_code"
  }
  
  /// Street address of this business.
  public let address1: String
  
  /// Street address of this business, continued.
  public let address2: String?
  
  /// Street address of this business, continued.
  public let address3: String?
  
  /// City of this business.
  public let city: String
  
  /// ISO 3166-1 alpha-2 country code of this business.
  public let country: String
  
  /// Array of strings that if organized vertically give an address
  /// that is in the standard address format for the business's country.
  public let displayAddress: [String]
  
  /// ISO 3166-2 (with a few exceptions) state code of this business.
  public let state: String
  
  /// Zip code of this business.
  public let zipCode: String
  
  init(withDict dict: [String: AnyObject]) throws {
    self.address1 = try dict.parseParam(key: Params.address1)
    self.address2 = try? dict.parseParam(key: Params.address2)
    self.address3 = try? dict.parseParam(key: Params.address3)
    self.city = try dict.parseParam(key: Params.city)
    self.country = try dict.parseParam(key: Params.country)
    self.displayAddress = (try? dict.parseParam(key: Params.display_address)) ?? []
    self.state = try dict.parseParam(key: Params.state)
    self.zipCode = try dict.parseParam(key: Params.zip_code)
  }
}
