//
//  YelpDataModels.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/24/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import UIKit

public struct YelpBusiness {
  /// Yelp ID for business
  public let id: String
  /// Whether business has been claimed by a business owner
  public let claimed: Bool
  /// Whether business has been (permenantly) closed
  public let closed: Bool
  /// Name of this business
  public let name: String
  /// url of photo for this business
  public let image: ImageReference?
  /// url for business page on Yelp
  public let url: URL
  /// url for mobile business page on Yelp
  public let mobileURL: URL
  /// Phone number for this business with international dialing code (e.g. +442079460000)
  public let phoneNumber: String?
  /// Phone number for this business formatted for display
  public let displayPhoneNumber: String?
  /// Number of reviews for this business
  public let reviewCount: Int
  /// Provides a list of category name, alias pairs that this business is associated with. For example, [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]] The alias is provided so you can search with the category_filter.
  public let categories: [YelpCategory]
  public let rating: YelpRating
  public let snippet: YelpSnippet
  /// Location data for this business
  public let location: YelpLocation
  ///	Deal info for this business (optional: this field is present only if there’s a Deal)
  public let deals: [YelpDeal]?
  /// Gift certificate info for this business (optional: this field is present only if there are gift certificates available)
  public let giftCertificates: [YelpGiftCertificate]?
  /// Provider of the menu for this busin
  public let menuProvider: String?
  /// Last time this menu was updated on Yelp (Unix timestamp)
  public let menuUpdateDate: Int?
  /// URL to the SeatMe reservation page for this business. This key will not be present if the business does not take reservations through SeatMe or if the query param 'actionlinks' is not set to True in the request
  public let reservationURL: URL?
  /// URL to the Eat24 page for this business. This key will not be present if the business does not offer delivery through Eat24 or if the query param 'actionlinks' is not set to True in the request
  public let eat24URL: URL?
  
  init(withDict dict: [String: AnyObject]) {
    self.id = dict["id"] as! String
    self.claimed = dict["is_claimed"] as! Bool
    self.closed = dict["is_closed"] as! Bool
    self.name = dict["name"] as! String
    if let imageURL = dict["image_url"] as? String {
      self.image = ImageReference(from: URL(string: imageURL)!)
    }
    else {
      self.image = nil
    }
    self.url = URL(string: dict["url"] as! String)!
    self.mobileURL = URL(string: dict["mobile_url"] as! String)!
    self.phoneNumber = dict["phone"] as? String
    self.displayPhoneNumber = dict["display_phone"] as? String
    self.reviewCount = dict["review_count"] as! Int
    var categories = [YelpCategory]()
    for category in dict["categories"] as! [[String]] {
      let yelpCategory = YelpCategory(withTuple: category)
      categories.append(yelpCategory)
    }
    self.categories = categories
    self.rating = YelpRating(withDict: dict)
    self.snippet = YelpSnippet(withDict: dict)
    self.location = YelpLocation(withDict: dict["location"] as! [String: AnyObject])
    if let deals = dict["deals"] as? [[String: AnyObject]] {
      var yelpDeals = [YelpDeal]()
      for deal in deals {
        let yelpDeal = YelpDeal(withDict: deal)
        yelpDeals.append(yelpDeal)
      }
      self.deals = yelpDeals
    }
    else {
      self.deals = nil
    }
    if let certificates = dict["gift_certificates"] as? [[String: AnyObject]] {
      var yelpCertificates = [YelpGiftCertificate]()
      for certificate in certificates {
        let yelpCertificate = YelpGiftCertificate(withDict: certificate)
        yelpCertificates.append(yelpCertificate)
      }
      self.giftCertificates = yelpCertificates
    }
    else {
      self.giftCertificates = nil
    }
    self.menuProvider = dict["menu_provider"] as? String
    self.menuUpdateDate = dict["menu_date_updated"] as? Int
    if let reservationURL = dict["reservation_url"] as? String {
      self.reservationURL = URL(string: reservationURL)
    }
    else {
      self.reservationURL = nil
    }
    if let eat24URL = dict["eat24_url"] as? String {
      self.eat24URL = URL(string: eat24URL)
    }
    else {
      self.eat24URL = nil
    }
  }
}

public struct YelpCategory {
  private enum Params {
    static let alias = "alias"
    static let title = "title"
  }
  public let categoryName: String
  public let alias: String
  
  init(withTuple tuple: [String]) {
    self.categoryName = tuple[0]
    self.alias = tuple[1]
  }
  
  init(withDict dict: [String: AnyObject]) throws {
    self.categoryName = try dict.parseParam(key: Params.title)
    self.alias = try dict.parseParam(key: Params.alias)
  }
  
  init(name: String, alias: String) {
    self.categoryName = name
    self.alias = alias
  }
}

public struct YelpRating {
  /// Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
  public let rating: Float
  /// URL to star rating image for this business (size = 84x17)
  public let image: ImageReference
  /// URL to small version of rating image for this business (size = 50x10)
  public let smallImage: ImageReference
  /// URL to large version of rating image for this business (size = 166x30)
  public let largeImage: ImageReference
  
  init(withDict dict: [String: AnyObject]) {
    self.rating = dict["rating"] as! Float
    self.image = ImageReference(from: URL(string: dict["rating_img_url"] as! String)!)
    self.smallImage = ImageReference(from: URL(string: dict["rating_img_url_small"] as! String)!)
    self.largeImage = ImageReference(from: URL(string: dict["rating_img_url_large"] as! String)!)
  }
}

public struct YelpSnippet {
  /// Snippet text associated with this business
  public let text: String?
  /// URL of snippet image associated with this business
  public let image: ImageReference?
  
  init(withDict dict: [String: AnyObject]) {
    self.text = dict["snippet_text"] as? String
    if let imageURL = dict["snippet_image_url"] as? String {
      self.image = ImageReference(from: URL(string: imageURL)!)
    }
    else {
      self.image = nil
    }
  }
}

public struct YelpLocation {
  /// Address for this business. Only includes address fields.
  public let address: [String]
  /// Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
  public let displayAddress: [String]
  /// City for this business
  public let city: String
  /// ISO 3166-2 state code for this business
  public let stateCode: String
  /// Postal code for this business
  public let postalCode: String?
  /// ISO 3166-1 country code for this business
  public let countryCode: String
  /// Cross streets for this business
  public let crossStreets: String?
  /// List that provides neighborhood(s) information for business
  public let neighborhoods: [String]?
  /// Coordinates of this location. This will be omitted if coordinates are not known for the location.
  public let coordinate: YelpGeoLocation?
  public let geoAccuraccy: Float
  
  init(withDict dict: [String: AnyObject]) {
    self.address = dict["address"] as! [String]
    self.displayAddress = dict["display_address"] as! [String]
    self.city = dict["city"] as! String
    self.stateCode = dict["state_code"] as! String
    self.postalCode = dict["postal_code"] as? String
    self.countryCode = dict["country_code"] as! String
    self.crossStreets = dict["cross_streets"] as? String
    self.neighborhoods = dict["neighborhoods"] as? [String]
    if let coordinate = dict["coordinate"] as? [String: Double] {
      self.coordinate = YelpGeoLocation(withDict: coordinate)
    }
    else {
      self.coordinate = nil
    }
    self.geoAccuraccy = dict["geo_accuracy"] as! Float
  }
}

public struct YelpGeoLocation {
  public let latitude: Double
  public let longitude: Double
  
  init(withDict dict: [String: Double]) {
    self.latitude = dict["latitude"]!
    self.longitude = dict["longitude"]!
  }
}

public struct YelpDeal {
  /// Deal identifier
  public let id: String?
  /// Deal title
  public let title: String
  /// Deal url
  public let url: URL
  /// Deal image url
  public let image: ImageReference
  /// ISO_4217 Currency Code
  public let currencyCode: String
  /// Deal start time (Unix timestamp)
  public let startTime: Int
  /// Deal end time (optional: this field is present only if the Deal ends)
  public let endTime: Int?
  /// Whether the Deal is popular (optional: this field is present only if true)
  public let popular: Bool?
  /// Additional details for the Deal, separated by newlines
  public let details: String?
  /// Important restrictions for the Deal, separated by newlines
  public let importantRestrictions: String?
  /// Deal additional restrictions
  public let additionalRestrictions: String?
  /// Deal options
  public let options: [YelpDealOptions]
  
  init(withDict dict: [String: AnyObject]) {
    self.id = dict["id"] as? String
    self.title = dict["title"] as! String
    self.url = URL(string: dict["url"] as! String)!
    self.image = ImageReference(from: URL(string: dict["image_url"] as! String)!)
    self.currencyCode = dict["currency_code"] as! String
    self.startTime = dict["time_start"] as! Int
    self.endTime = dict["time_end"] as? Int
    self.popular = dict["is_popular"] as? Bool
    self.details = dict["what_you_get"] as? String
    self.importantRestrictions = dict["important_restrictions"] as? String
    self.additionalRestrictions = dict["additional_restrictions"] as? String
    var options = [YelpDealOptions]()
    for option in dict["options"] as! [[String: AnyObject]] {
      let yelpDealOption = YelpDealOptions(withDict: option)
      options.append(yelpDealOption)
    }
    self.options = options
  }
}

public struct YelpDealOptions {
  /// Deal option title
  public let title: String
  /// 	Deal option url for purchase
  public let purchaseURL: URL
  /// Deal option price (in cents)
  public let price: Int
  /// Deal option price (formatted, e.g. "$6")
  public let formattedPrice: String
  /// Deal option original price (in cents)
  public let originalPrice: Int
  /// Deal option original price (formatted, e.g. "$12")
  public let formattedOriginalPrice: String
  /// Whether the deal option is limited or unlimited
  public let limitedQuantity: Bool
  /// The remaining deal options available for purchase (optional: this field is only present if the deal is limited)
  public let remainingCount: Int?
  
  init(withDict dict: [String: AnyObject]) {
    self.title = dict["title"] as! String
    self.purchaseURL = URL(string: dict["purchase_url"] as! String)!
    self.price = dict["price"] as! Int
    self.formattedPrice = dict["formatted_price"] as! String
    self.originalPrice = dict["original_price"] as! Int
    self.formattedOriginalPrice = dict["formatted_original_price"] as! String
    self.limitedQuantity = dict["is_quantity_limited"] as! Bool
    self.remainingCount = dict["remaining_count"] as? Int
  }
}

public struct YelpGiftCertificate {
  /// Gift certificate identifier
  public let id: String
  /// Gift certificate landing page url
  public let url: URL
  /// Gift certificate image url
  public let image: ImageReference
  /// ISO_4217 Currency Code
  public let currencyCode: String
  /// Whether unused balances are returned as cash or store credit
  public let unusedBalances: String
  /// Gift certificate options
  public let options: [YelpGiftCertificateOption]
  
  init(withDict dict: [String: AnyObject]) {
    self.id = dict["id"] as! String
    self.url = URL(string: dict["url"] as! String)!
    self.image = ImageReference(from: URL(string: dict["image_url"] as! String)!)
    self.currencyCode = dict["currency_code"] as! String
    self.unusedBalances = dict["unused_balances"] as! String
    var options = [YelpGiftCertificateOption]()
    for option in dict["options"] as! [[String: AnyObject]] {
      let yelpOption = YelpGiftCertificateOption(withDict: option)
      options.append(yelpOption)
    }
    self.options = options
  }
}

public struct YelpGiftCertificateOption {
  /// Gift certificate option price (in cents)
  public let price: Int
  /// Gift certificate option price (formatted, e.g. "$50")
  public let formattedPrice: String
  
  init(withDict dict: [String: AnyObject]) {
    self.price = dict["price"] as! Int
    self.formattedPrice = dict["formatted_price"] as! String
  }
}
