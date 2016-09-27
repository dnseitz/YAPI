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

protocol YelpBooleanParameter : ExpressibleByBooleanLiteral, YelpParameter {
  var internalValue: Bool { get }
}

protocol YelpStringParameter : ExpressibleByStringLiteral, YelpParameter {
  var internalValue: String { get }
}

protocol YelpIntParameter : ExpressibleByIntegerLiteral, YelpParameter {
  var internalValue: Int { get }
}

protocol YelpArrayParameter : ExpressibleByArrayLiteral, YelpParameter {
  var internalValue: [Self.Element] { get }
  
  init?(_ elements: [Self.Element]?)
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
  
  public init?(_ value: BooleanLiteralType?) {
    if let value = value {
      self.init(booleanLiteral: value)
    }
    else {
      return nil
    }
  }
}

extension YelpStringParameter {
  public var value: String {
    return self.internalValue
  }
  
  public init?(_ value: StringLiteralType?) {
    if let value = value {
      self.init(stringLiteral: value)
    }
    else {
      return nil
    }
  }
}

extension YelpIntParameter {
  public var value: String {
    return String(self.internalValue)
  }
  
  public init?(_ value: IntegerLiteralType?) {
    if let value = value {
      self.init(integerLiteral: value)
    }
    else {
      return nil
    }
  }
}

extension YelpArrayParameter {
  public var value: String {
    return self.internalValue.map() { "\($0)" }.joined(separator: ",")
  }
  
  public init(arrayLiteral elements: Self.Element...) {
    self.init(elements)!
  }
}
