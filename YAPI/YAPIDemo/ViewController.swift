//
//  ViewController.swift
//  YAPIDemo
//
//  Created by Daniel Seitz on 9/26/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit
import YAPI

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let parameters = YelpV3TokenParameters(grantType: .clientCredentials, clientId: "YvxjDSJzUHNbMDcxZ-1XTQ", clientSecret: "l79vZwLjzgoO9Gt6N6Gs6H5NJ85VBL1OOksSpfZTuvbcYzpqeGr3jzT7XNbYzBy5")
    let tokenAuthRequest = YelpAPIFactory.V3.makeTokenRequest(with: parameters)
    tokenAuthRequest.send { (response, error) in
      if let error = error {
        print(error)
      }
      print(response?.accessToken)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

