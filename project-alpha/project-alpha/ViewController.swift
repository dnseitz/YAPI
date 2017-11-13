//
//  ViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/12/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import YAPI

class ViewController: UIViewController {
  
  private func getKeys() -> [String: String] {
    guard
      let path = Bundle.main.path(forResource: "secrets", ofType: "plist"),
      let keys = NSDictionary(contentsOfFile: path) as? [String: String]
      else {
        assertionFailure("Unable to load secrets property list, contact dnseitz@gmail.com if you need the file")
        return [:]
    }
    return keys
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let keys = getKeys()
    guard
      let appId = keys["APP_ID"],
      let clientSecret = keys["CLIENT_SECRET"]
      else {
        assertionFailure("Unable to retrieve appId or clientSecret from file")
        return
    }
    
    YelpAPIFactory.V3.authenticate(appId: appId, clientSecret: clientSecret) { error in
      if let error = error {
        print("\(error)")
      }
      else {
        print("Authenticated")
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

