//
//  YelpDataModels.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/24/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import UIKit

struct YelpBusiness {
  /// Yelp ID for business
  let id: String
  /// Whether business has been claimed by a business owner
  let claimed: Bool
  /// Whether business has been (permenantly) closed
  let closed: Bool
  /// Name of this business
  let name: String
  /// url of photo for this business
  let image: ImageReference?
  /// url for business page on Yelp
  let url: NSURL
  /// url for mobile business page on Yelp
  let mobileURL: NSURL
  /// Phone number for this business with international dialing code (e.g. +442079460000)
  let phoneNumber: String?
  /// Phone number for this business formatted for display
  let displayPhoneNumber: String?
  /// Number of reviews for this business
  let reviewCount: Int
  /// Provides a list of category name, alias pairs that this business is associated with. For example, [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]] The alias is provided so you can search with the category_filter.
  let categories: [YelpCategory]
  let rating: YelpRating
  let snippet: YelpSnippet
  /// Location data for this business
  let location: YelpLocation
  ///	Deal info for this business (optional: this field is present only if there’s a Deal)
  let deals: [YelpDeal]?
  /// Gift certificate info for this business (optional: this field is present only if there are gift certificates available)
  let giftCertificates: [YelpGiftCertificate]?
  /// Provider of the menu for this busin
  let menuProvider: String?
  /// Last time this menu was updated on Yelp (Unix timestamp)
  let menuUpdateDate: Int?
  /// URL to the SeatMe reservation page for this business. This key will not be present if the business does not take reservations through SeatMe or if the query param 'actionlinks' is not set to True in the request
  let reservationURL: NSURL?
  /// URL to the Eat24 page for this business. This key will not be present if the business does not offer delivery through Eat24 or if the query param 'actionlinks' is not set to True in the request
  let eat24URL: NSURL?
  
  init(withDict dict: [String: AnyObject]) {
    self.id = dict["id"] as! String
    self.claimed = dict["is_claimed"] as! Bool
    self.closed = dict["is_closed"] as! Bool
    self.name = dict["name"] as! String
    if let imageURL = dict["image_url"] as? String {
      self.image = ImageReference(from: NSURL(string: imageURL)!)
    }
    else {
      self.image = nil
    }
    self.url = NSURL(string: dict["url"] as! String)!
    self.mobileURL = NSURL(string: dict["mobile_url"] as! String)!
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
      self.reservationURL = NSURL(string: reservationURL)
    }
    else {
      self.reservationURL = nil
    }
    if let eat24URL = dict["eat24_url"] as? String {
      self.eat24URL = NSURL(string: eat24URL)
    }
    else {
      self.eat24URL = nil
    }
  }
}

struct YelpCategory {
  let categoryName: String
  let alias: String
  
  init(withTuple tuple: [String]) {
    self.categoryName = tuple[0]
    self.alias = tuple[1]
  }
}

struct YelpRating {
  /// Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
  let rating: Float
  /// URL to star rating image for this business (size = 84x17)
  let image: ImageReference
  /// URL to small version of rating image for this business (size = 50x10)
  let smallImage: ImageReference
  /// URL to large version of rating image for this business (size = 166x30)
  let largeImage: ImageReference
  
  init(withDict dict: [String: AnyObject]) {
    self.rating = dict["rating"] as! Float
    self.image = ImageReference(from: NSURL(string: dict["rating_img_url"] as! String)!)
    self.smallImage = ImageReference(from: NSURL(string: dict["rating_img_url_small"] as! String)!)
    self.largeImage = ImageReference(from: NSURL(string: dict["rating_img_url_large"] as! String)!)
  }
}

struct YelpSnippet {
  /// Snippet text associated with this business
  let text: String?
  /// URL of snippet image associated with this business
  let image: ImageReference?
  
  init(withDict dict: [String: AnyObject]) {
    self.text = dict["snippet_text"] as? String
    if let imageURL = dict["snippet_image_url"] as? String {
      self.image = ImageReference(from: NSURL(string: imageURL)!)
    }
    else {
      self.image = nil
    }
  }
}

struct YelpLocation {
  /// Address for this business. Only includes address fields.
  let address: [String]
  /// Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
  let displayAddress: [String]
  /// City for this business
  let city: String
  /// ISO 3166-2 state code for this business
  let stateCode: String
  /// Postal code for this business
  let postalCode: String?
  /// ISO 3166-1 country code for this business
  let countryCode: String
  /// Cross streets for this business
  let crossStreets: String?
  /// List that provides neighborhood(s) information for business
  let neighborhoods: [String]?
  /// Coordinates of this location. This will be omitted if coordinates are not known for the location.
  let coordinate: YelpGeoLocation?
  let geoAccuraccy: Float
  
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

struct YelpGeoLocation {
  let latitude: Double
  let longitude: Double
  
  init(withDict dict: [String: Double]) {
    self.latitude = dict["latitude"]!
    self.longitude = dict["longitude"]!
  }
}

struct YelpDeal {
  /// Deal identifier
  let id: String
  /// Deal title
  let title: String
  /// Deal url
  let url: NSURL
  /// Deal image url
  let image: ImageReference
  /// ISO_4217 Currency Code
  let currencyCode: String
  /// Deal start time (Unix timestamp)
  let startTime: Int
  /// Deal end time (optional: this field is present only if the Deal ends)
  let endTime: Int?
  /// Whether the Deal is popular (optional: this field is present only if true)
  let popular: Bool?
  /// Additional details for the Deal, separated by newlines
  let details: String
  /// Important restrictions for the Deal, separated by newlines
  let importantRestrictions: String
  /// Deal additional restrictions
  let additionalRestrictions: String
  /// Deal options
  let options: [YelpDealOptions]  
  
  init(withDict dict: [String: AnyObject]) {
    self.id = dict["id"] as! String
    self.title = dict["title"] as! String
    self.url = NSURL(string: dict["url"] as! String)!
    self.image = ImageReference(from: NSURL(string: dict["image_url"] as! String)!)
    self.currencyCode = dict["currency_code"] as! String
    self.startTime = dict["time_start"] as! Int
    self.endTime = dict["time_end"] as? Int
    self.popular = dict["is_popular"] as? Bool
    self.details = dict["what_you_get"] as! String
    self.importantRestrictions = dict["important_restrictions"] as! String
    self.additionalRestrictions = dict["additional_restrictions"] as! String
    var options = [YelpDealOptions]()
    for option in dict["options"] as! [[String: AnyObject]] {
      let yelpDealOption = YelpDealOptions(withDict: option)
      options.append(yelpDealOption)
    }
    self.options = options
  }
}

struct YelpDealOptions {
  /// Deal option title
  let title: String
  /// 	Deal option url for purchase
  let purchaseURL: NSURL
  /// Deal option price (in cents)
  let price: Int
  /// Deal option price (formatted, e.g. "$6")
  let formattedPrice: String
  /// Deal option original price (in cents)
  let originalPrice: Int
  /// Deal option original price (formatted, e.g. "$12")
  let formattedOriginalPrice: String
  /// Whether the deal option is limited or unlimited
  let limitedQuantity: Bool
  /// The remaining deal options available for purchase (optional: this field is only present if the deal is limited)
  let remainingCount: Int?  
  
  init(withDict dict: [String: AnyObject]) {
    self.title = dict["title"] as! String
    self.purchaseURL = NSURL(string: dict["purchase_url"] as! String)!
    self.price = dict["price"] as! Int
    self.formattedPrice = dict["formatted_price"] as! String
    self.originalPrice = dict["original_price"] as! Int
    self.formattedOriginalPrice = dict["formatted_original_price"] as! String
    self.limitedQuantity = dict["is_quantity_limited"] as! Bool
    self.remainingCount = dict["remaining_count"] as? Int
  }
}

struct YelpGiftCertificate {
  /// Gift certificate identifier
  let id: String
  /// Gift certificate landing page url
  let url: NSURL
  /// Gift certificate image url
  let image: ImageReference
  /// ISO_4217 Currency Code
  let currencyCode: String
  /// Whether unused balances are returned as cash or store credit
  let unusedBalances: String
  /// Gift certificate options
  let options: [YelpGiftCertificateOption]  
  
  init(withDict dict: [String: AnyObject]) {
    self.id = dict["id"] as! String
    self.url = NSURL(string: dict["url"] as! String)!
    self.image = ImageReference(from: NSURL(string: dict["image_url"] as! String)!)
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

struct YelpGiftCertificateOption {
  /// Gift certificate option price (in cents)
  let price: Int
  /// Gift certificate option price (formatted, e.g. "$50")
  let formattedPrice: String  
  
  init(withDict dict: [String: AnyObject]) {
    self.price = dict["price"] as! Int
    self.formattedPrice = dict["formatted_price"] as! String
  }
}