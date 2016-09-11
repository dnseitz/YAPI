//
//  YelpErrors.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/27/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

/**
    A protocol describing an error caused by either a YelpRequest or YelpResponse
 */
public protocol YelpError: ErrorType, CustomStringConvertible {}

/**
    Errors that occur while trying to send the request
 */
public enum YelpRequestError: YelpError, Equatable {
  /// The request was unable to be generated, possibly a malformed url
  case FailedToGenerateRequest
  /// The request failed to send for some reason, see the wrapped NSError for details
  case FailedToSendRequest(NSError)
  /// Some form of location data in the request is required for a valid request
  case NoLocationData
  
  public var description: String {
    switch self {
    case .FailedToGenerateRequest:
      return "Failed to generate the Network Request for some reason"
    case let .FailedToSendRequest(err):
      return "Failed to send request (\(err.code))"
    case .NoLocationData:
      return "Request must have some form of location data to be sent"
    }
  }
}

public func ==(lhs: YelpRequestError, rhs: YelpRequestError) -> Bool {
  switch (lhs, rhs) {
  case(.FailedToGenerateRequest, .FailedToGenerateRequest):
    return true
  case(let .FailedToSendRequest(err1), let .FailedToSendRequest(err2)):
    return err1.domain == err2.domain && err1.code == err2.code
  case(.NoLocationData, .NoLocationData):
    return true
  default:
    return false
  }
}

/**
    Errors that can return from a Yelp response and if there are any issues generating the response
 */
public enum YelpResponseError: YelpError, Equatable {
  /// An unknown error occurred with the Yelp service
  case UnknownError
  /// An internal service error occurred with the Yelp service
  case InternalError
  /// The number of requests for the api used has exceeded its limit
  case ExceededRequests
  /// A required parameter was missing, see the wrapped string for the parameter
  case MissingParameter(field: String)
  /// A parameter was invalid, see the wrapped string for the parameter
  case InvalidParameter(field: String)
  /// Yelp is not available for the requested location
  case UnavailableForLocation
  /// The search area is too large
  case AreaTooLarge
  /// The Yelp service was unable to disambiguate the search location
  case MultipleLocations
  /// Information for a specific business is unavailable
  case BusinessUnavailable
  /// No data was recieved in the response
  case NoDataRecieved
  /// Data was recieved, but it couldn't be parsed as JSON
  case FailedToParse
  
  public var description: String {
    switch self {
    case .UnknownError:
      return "An unknown error has occurred"
    case .InternalError:
      return "An internal Yelp service error has occurred"
    case .ExceededRequests:
      return "The number of requests for the api used has exceeded its limit"
    case let .MissingParameter(field: field):
      return "A required parameter was missing: '\(field)'"
    case let .InvalidParameter(field: field):
      return "A parameter was invalid: '\(field)'"
    case .UnavailableForLocation:
      return "Yelp is unavailable in the requested location"
    case .AreaTooLarge:
      return "The search area is too large, maximum area is 2,500 square miles"
    case .MultipleLocations:
      return "Yelp is unable to disambiguate the search location"
    case .BusinessUnavailable:
      return "Information for that business is unavailable"
    case .NoDataRecieved:
      return "No data was recieved in the response"
    case .FailedToParse:
      return "The data recieved was unable to be parsed"
    }
  }
}

public func ==(lhs: YelpResponseError, rhs: YelpResponseError) -> Bool {
  switch (lhs, rhs) {
  case(.UnknownError, .UnknownError):
    return true
  case(.InternalError, .InternalError):
    return true
  case (.ExceededRequests, .ExceededRequests):
    return true
  case (let .MissingParameter(field: field1), let .MissingParameter(field: field2)):
    return field1 == field2
  case (let .InvalidParameter(field: field1), let .InvalidParameter(field: field2)):
    return field1 == field2
  case (.UnavailableForLocation, .UnavailableForLocation):
    return true
  case (.AreaTooLarge, .AreaTooLarge):
    return true
  case (.MultipleLocations, .MultipleLocations):
    return true
  case (.BusinessUnavailable, .BusinessUnavailable):
    return true
  case (.NoDataRecieved, .NoDataRecieved):
    return true
  case (.FailedToParse, .FailedToParse):
    return true
  default:
    return false
  }
}