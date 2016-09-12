//
//  YelpParameter.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public protocol YelpParameter : CustomStringConvertible {
  var key: String { get }
  var value: String { get }
}

protocol YelpBooleanParameter : BooleanLiteralConvertible, YelpParameter {
  var internalValue: Bool { get }
}

protocol YelpStringParameter : StringLiteralConvertible, YelpParameter {
  var internalValue: String { get }
}

protocol YelpIntParameter : IntegerLiteralConvertible, YelpParameter {
  var internalValue: Int { get }
}

protocol YelpArrayParameter : ArrayLiteralConvertible, YelpParameter {
  var internalValue: [Self.Element] { get }
}

extension YelpParameter {
  public var description: String {
    return self.value
  }
}

extension YelpBooleanParameter {
  public var value: String {
    return String(self.internalValue)
  }
}

extension YelpStringParameter {
  public var value: String {
    return self.internalValue
  }
}

extension YelpIntParameter {
  public var value: String {
    return String(self.internalValue)
  }
}

extension YelpArrayParameter {
  public var value: String {
    return self.internalValue.map() { "\($0)" }.joinWithSeparator(",")
  }
}
