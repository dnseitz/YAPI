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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    YelpAPIFactory.V3.authenticate(appId: "", clientSecret: "") { error in
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

