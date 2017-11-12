//
//  YelpRegionDataModels.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

public struct YelpRegion {
  
  /// Span of suggested map bounds
  let span: YelpRegionSpan?
  
  /// Center position of map bounds
  let center: YelpRegionCenter
  
  init(withDict dict: [String: AnyObject]) {
    if let span = dict["span"] as? [String: AnyObject] {
      self.span = YelpRegionSpan(withDict: span)
    }
    else {
      self.span = nil
    }
    self.center = YelpRegionCenter(withDict: dict["center"] as! [String: AnyObject])
  }
}

struct YelpRegionSpan {
  
  /// Latitude width of map bounds
  let latitudeDelta: Double
  
  /// Longitude height of map bounds
  let longitudeDelta: Double
  
  init(withDict dict: [String: AnyObject]) {
    self.latitudeDelta = dict["latitude_delta"] as! Double
    self.longitudeDelta = dict["longitude_delta"] as! Double
  }
}

struct YelpRegionCenter {
  
  /// Latitude position of map bounds center
  let latitude: Double
  
  /// Longitude position of map bounds center
  let longitude: Double
  
  init(withDict dict: [String: AnyObject]) {
    self.latitude = dict["latitude"] as! Double
    self.longitude = dict["longitude"] as! Double
  }
}
