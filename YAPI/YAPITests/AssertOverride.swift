//
//  AssertOverride.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/1/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

enum Asserts {
  static var shouldAssert: Bool = true
}

// Disable asserts for testing
func assert(@autoclosure condition: () -> Bool, @autoclosure _ message: () -> String = "", file: StaticString = #file, line: UInt = #line) {
  if Asserts.shouldAssert {
    Swift.assert(condition, message, file: file, line: line)
  }
  else {
    print("Assertion with message: \(message()) in file: \(file) at line: \(line)")
  }
}