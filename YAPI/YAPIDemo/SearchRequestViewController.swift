//
//  SearchRequestViewController.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/26/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit
import YAPI

class SearchRequestViewController: UIViewController {
  @IBOutlet weak var term: UISwitch!
  @IBOutlet weak var limit: UITextField!
  @IBOutlet weak var offset: UITextField!
  @IBOutlet weak var sortMode: UISegmentedControl!
  @IBOutlet weak var radius: UITextField!
  @IBOutlet weak var deals: UISwitch!
  @IBOutlet weak var categories: UITextField!
  
  @IBOutlet weak var send: UIButton!
  
  @IBOutlet weak var responseField: UITextView!
  
  var searchParameters: YelpV2SearchParameters = YelpV2SearchParameters(location: "Portland, OR" as YelpSearchLocation)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    send.addTarget(self, action: #selector(sendRequest(sender:)), for: .touchUpInside)
    
    responseField.text = ""
  }
  
  func sendRequest(sender: UIButton) {
    clearParameters()
    
    setTerm()
    setLimit()
    setOffset()
    setSortMode()
    setRadius()
    setDeals()
    setCategories()
    
    let request = YelpAPIFactory.V2.makeSearchRequest(with: self.searchParameters)
    
    request.send { (response, error) in
      var text = ""
      defer {
        print(text)
        DispatchQueue.main.async {
          self.responseField.text = text
        }
      }
      if let error = error {
        text += "Error recieved: \(error)\n"
      }
      
      guard let response = response else { return }
      if response.wasSuccessful {
        for business in response.businesses! {
          text += "\(business.name)\n"
        }
      }
      else {
        text += "\(response.error)\n"
      }
    }
  }
  
  func setTerm() {
    if self.term.isOn {
      self.searchParameters.term = .food
    }
    else {
      self.searchParameters.term = .drink
    }
  }
  
  func setLimit() {
    guard let value = self.limit.text else { return }
    self.searchParameters.limit = YelpV2SearchParameters.Limit(Int(value))
  }
  
  func setOffset() {
    guard let value = self.offset.text else { return }
    self.searchParameters.offset = YelpV2SearchParameters.Offset(Int(value))
  }
  
  func setSortMode() {
    let mode: YelpV2SearchParameters.SortMode
    switch self.sortMode.selectedSegmentIndex {
    case 0:
      mode = .best
      break
    case 1:
      mode = .distance
      break
    case 2:
      mode = .highestRated
      break
    default:
      return
    }
    self.searchParameters.sortMode = mode
  }
  
  func setRadius() {
    guard let value = self.offset.text else { return }
    self.searchParameters.radius = YelpV2SearchParameters.Radius(Int(value))
  }
  
  func setDeals() {
    self.searchParameters.filterDeals = YelpV2SearchParameters.Deals(self.deals.isOn)
  }
  
  func setCategories() {
    guard let value = self.categories.text else { return }
    let array = value.components(separatedBy: ",")
    let categories = array.map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
    self.searchParameters.categories = YelpV2SearchParameters.Categories(categories)
  }
  
  func clearParameters() {
    self.searchParameters = YelpV2SearchParameters(location: "Portland, OR" as YelpSearchLocation)
  }
}
