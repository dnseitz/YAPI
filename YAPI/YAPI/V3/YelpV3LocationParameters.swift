//
//  YelpV3LocationParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

public struct YelpV3LocationParameter {
  public struct Location : YelpStringParameter {
    let internalValue: String
    
    public var key: String {
      return "location"
    }
  }
  
  public struct Latitude : YelpDoubleParameter {
    let internalValue: Double
    
    public var key: String {
      return "latitude"
    }
    
    public init(floatLiteral value: FloatLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Longitude : YelpDoubleParameter {
    let internalValue: Double
    
    public var key: String {
      return "longitude"
    }
    
    public init(floatLiteral value: FloatLiteralType) {
      self.internalValue = value
    }
  }
  
  /// Specifies the combination of "address, neighborhood, city, state or zip, optional country" to be used when searching for businesses.
  let location: Location?
  
  /// Latitude of the location you want to search near by.
  let latitude: Latitude?
  
  /// Longitude of the location you want to search near by.
  let longitude: Longitude?
  
  public init(location: Location) {
    self.location = location
    self.latitude = nil
    self.longitude = nil
  }
  
  public init(latitude: Latitude, longitude: Longitude) {
    self.location = nil
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public init(coordinate: CLLocationCoordinate2D) {
    self.location = nil
    self.latitude = Latitude(coordinate.latitude)
    self.longitude = Longitude(coordinate.longitude)
  }
  
  public init(location: CLLocation) {
    self.init(coordinate: location.coordinate)
  }
}

extension YelpV3LocationParameter.Location {
  public typealias UnicodeScalarLiteralType = Character
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  
  public init(stringLiteral value: StringLiteralType) {
    self.internalValue = value
  }
  
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.internalValue = "\(value)"
  }
  
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.internalValue = value
  }
}
