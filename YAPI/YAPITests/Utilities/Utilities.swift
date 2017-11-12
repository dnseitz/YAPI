//
//  Utilities.swift
//  YAPITests
//
//  Created by Daniel Seitz on 11/11/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

internal func compare(_ x: Double, _ y: Double) -> Bool {
  return fabs(x - y) < Double.ulpOfOne
}
