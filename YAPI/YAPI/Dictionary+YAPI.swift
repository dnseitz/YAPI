//
//  Dictionary+YAPI.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringLiteralConvertible, Value: StringLiteralConvertible {
  mutating func insertParameter(parameter: YelpParameter) {
    if let key = parameter.key as? Key, value = parameter.value as? Value {
      self[key] = value
    }
  }
}