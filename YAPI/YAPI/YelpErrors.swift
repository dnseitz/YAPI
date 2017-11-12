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
public protocol YelpError: Error, CustomStringConvertible {}

/**
    Errors that occur while trying to send the request
 */
public enum YelpRequestError: YelpError, Equatable {
  /// The request was unable to be generated, possibly a malformed url
  case failedToGenerateRequest
  /// The request failed to send for some reason, see the wrapped NSError for details
  case failedToSendRequest(NSError)
  
  public var description: String {
    switch self {
    case .failedToGenerateRequest:
      return "Failed to generate the Network Request for some reason"
    case let .failedToSendRequest(err):
      return "Failed to send request (\(err.code))"
    }
  }
}

public func ==(lhs: YelpRequestError, rhs: YelpRequestError) -> Bool {
  switch (lhs, rhs) {
  case(.failedToGenerateRequest, .failedToGenerateRequest):
    return true
  case(let .failedToSendRequest(err1), let .failedToSendRequest(err2)):
    return err1.domain == err2.domain && err1.code == err2.code
  default:
    return false
  }
}

/**
    Errors that can return from a Yelp response and if there are any issues generating the response
 */
public enum YelpResponseError: YelpError, Equatable {
  /// An unknown error occurred with the Yelp service
  case unknownError
  /// An internal service error occurred with the Yelp service
  case internalError
  /// The number of requests for the api used has exceeded its limit
  case exceededRequests
  /// A required parameter was missing, see the wrapped string for the parameter
  case missingParameter(field: String)
  /// A parameter was invalid, see the wrapped string for the parameter
  case invalidParameter(field: String)
  /// Yelp is not available for the requested location
  case unavailableForLocation
  /// The search area is too large
  case areaTooLarge
  /// The Yelp service was unable to disambiguate the search location
  case multipleLocations
  /// Information for a specific business is unavailable
  case businessUnavailable
  /// No data was recieved in the response
  case noDataRecieved
  /// Data was recieved, but it couldn't be parsed as JSON
  case failedToParse(cause: YelpError)
  /// Resource could not be found
  case notFound
  
  public var description: String {
    switch self {
    case .unknownError:
      return "An unknown error has occurred"
    case .internalError:
      return "An internal Yelp service error has occurred"
    case .exceededRequests:
      return "The number of requests for the api used has exceeded its limit"
    case let .missingParameter(field: field):
      return "A required parameter was missing: '\(field)'"
    case let .invalidParameter(field: field):
      return "A parameter was invalid: '\(field)'"
    case .unavailableForLocation:
      return "Yelp is unavailable in the requested location"
    case .areaTooLarge:
      return "The search area is too large, maximum area is 2,500 square miles"
    case .multipleLocations:
      return "Yelp is unable to disambiguate the search location"
    case .businessUnavailable:
      return "Information for that business is unavailable"
    case .noDataRecieved:
      return "No data was recieved in the response"
    case .failedToParse(cause: let cause):
      return "The data recieved was unable to be parsed: '\(cause)'"
    case .notFound:
      return "The resource could not be found."
    }
  }
}

public func ==(lhs: YelpResponseError, rhs: YelpResponseError) -> Bool {
  switch (lhs, rhs) {
  case(.unknownError, .unknownError):
    return true
  case(.internalError, .internalError):
    return true
  case (.exceededRequests, .exceededRequests):
    return true
  case (let .missingParameter(field: field1), let .missingParameter(field: field2)):
    return field1 == field2
  case (let .invalidParameter(field: field1), let .invalidParameter(field: field2)):
    return field1 == field2
  case (.unavailableForLocation, .unavailableForLocation):
    return true
  case (.areaTooLarge, .areaTooLarge):
    return true
  case (.multipleLocations, .multipleLocations):
    return true
  case (.businessUnavailable, .businessUnavailable):
    return true
  case (.noDataRecieved, .noDataRecieved):
    return true
  case (.failedToParse(cause: _), .failedToParse(cause: _)):
    return true
  case (.notFound, .notFound):
    return true
  default:
    return false
  }
}

public enum YelpParseError: YelpError, Equatable {
  
  // The data is not in JSON format
  case invalidJson
  
  // A required field was missing in the response
  case missing(field: String)
  
  // A piece of data was not recognized
  case invalid(field: String, value: String)
  
  // The cause of the failure is unknown
  case unknown
  
  public var description: String {
    switch self {
    case .invalidJson:
      return "The data is not in JSON format"
    case .missing(field: let field):
      return "A required field <\(field)> was missing in the response"
    case .invalid(field: let field, value: let value):
      return "A piece of data was not recognized <\(field): \(value)>"
    case .unknown:
      return "The cause of the failure is unknown"
    }
  }
}

public func ==(lhs: YelpParseError, rhs: YelpParseError) -> Bool {
  switch (lhs, rhs) {
  case (.invalidJson, .invalidJson):
    return true
  case (.missing(field: let field1), .missing(field: let field2)):
    return field1 == field2
  case (.invalid(field: let field1, value: _), .invalid(field: let field2, value: _)):
    return field1 == field2
  case (.unknown, .unknown):
    return true
  default:
    return false
  }
}
