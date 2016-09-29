//
//  YelpLocationParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

/**
    There are three available methods to specify location in a search. The location is a required 
    parameter, and exactly one of these methods should be used for a request.
 */
public protocol YelpLocationParameter : YelpParameter {}

internal protocol InternalLocation : YelpLocationParameter {
  var hint: YelpSearchLocation.HintParameter? { get }
}

/**
    Location is specified by a particular neighborhood, address or city.
 */
public struct YelpSearchLocation : InternalLocation, YelpStringParameter {
  public struct HintParameter : YelpParameter {
    let cll: String
    
    public var key: String {
      return "cll"
    }
    
    public var value: String {
      return cll
    }
    
    init(location: CLLocation) {
      self.init(coordinate: location.coordinate)
    }
    
    init(coordinate: CLLocationCoordinate2D) {
      self.cll = "\(coordinate.latitude),\(coordinate.longitude)"
    }
  }
  
  /// Specifies the combination of "address, neighborhood, city, state or zip, optional country" to be used when searching for businesses.
  let internalValue: String
  
  /// An optional latitude, longitude parameter can also be specified as a hint to the geocoder to disambiguate the location text.
  let hint: HintParameter?
  
  public var key: String {
    return "location"
  }
  
  init(location: String, locationHint hint: CLLocation? = nil) {
    self.init(location: location, coordinateHint: hint?.coordinate)
  }
  
  init(location: String, coordinateHint hint: CLLocationCoordinate2D? = nil) {
    self.internalValue = location
    if let hint = hint {
      self.hint = HintParameter(coordinate: hint)
    }
    else {
      self.hint = nil
    }
  }
}

extension YelpSearchLocation : ExpressibleByStringLiteral {
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public typealias UnicodeScalarLiteralType = Character
  
  public init(stringLiteral value: StringLiteralType) {
    self.internalValue = value
    self.hint = nil
  }
  
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.internalValue = "\(value)"
    self.hint = nil
  }
  
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.internalValue = value
    self.hint = nil
  }
}

/**
    Location is specified by a bounding box, defined by a southwest latitude/longitude and a northeast 
    latitude/longitude geographic coordinate.
 */
public struct YelpBoundingBox : InternalLocation {
  let southWest: CLLocationCoordinate2D
  let northEast: CLLocationCoordinate2D
  let hint: YelpSearchLocation.HintParameter? = nil
  
  public var key: String {
    return "bounds"
  }
  
  public var value: String {
    return "\(southWest.latitude),\(southWest.longitude)|\(northEast.latitude),\(northEast.longitude)"
  }
  
  init(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) {
    self.southWest = southWest
    self.northEast = northEast
  }
}

public struct YelpGeographicCoordinate : InternalLocation {
  
  /// Coordinate of geo-point to search near
  let coordinate: CLLocationCoordinate2D
  
  /// Accuracy of latitude, longitude
  let accuracy: Double?
  
  /// Altitude
  let altitude: Double?
  
  /// Accuracy of altitude
  let altitudeAccuracy: Double?
  let hint: YelpSearchLocation.HintParameter? = nil
  
  public var key: String {
    return "ll"
  }
  
  public var value: String {
    var rest = ""
    if let accuracy = accuracy {
      rest += ",\(accuracy)"
      if let altitude = altitude {
        rest += ",\(altitude)"
      }
        if let altitudeAccuracy = altitudeAccuracy {
          rest += ",\(altitudeAccuracy)"
        }
    }
    return "\(coordinate.latitude),\(coordinate.longitude)" + rest
  }
}
