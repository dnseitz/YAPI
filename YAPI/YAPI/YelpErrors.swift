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
public enum YelpRequestError: YelpError {
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

/**
    Errors that can return from a Yelp response and if there are any issues generating the response
 */
public enum YelpResponseError: YelpError {
  /// An unknown error occurred with the Yelp service
  case unknownError(cause: Error?)
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
  case failedToParse(cause: YelpParseError)
  /// Resource could not be found
  case notFound
  /// An access token must be supplied in order to use this endpoint,
  /// make sure you have authenticated through the YelpAPIFactory
  case tokenMissing
  
  public var description: String {
    switch self {
    case .unknownError(cause: let cause):
      let causeDescription: String
      if let cause = cause {
        causeDescription = ": \(cause)"
      }
      else {
        causeDescription = ""
      }
      return "An unknown error has occurred" + causeDescription
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
    case .tokenMissing:
      return "An access token must be supplied in order to use this endpoint, make sure you have authenticated through the YelpAPIFactory"
    }
  }
}

public enum YelpParseError: YelpError {
  
  // The data is not in JSON format
  case invalidJson(cause: Error)
  
  // A required field was missing in the response
  case missing(field: String)
  
  // A piece of data was not recognized
  case invalid(field: String, value: String)
  
  // The cause of the failure is unknown
  case unknown
  
  public var description: String {
    switch self {
    case .invalidJson(cause: let cause):
      return "The data is not in JSON format: <\(cause)>"
    case .missing(field: let field):
      return "A required field <\(field)> was missing in the response"
    case .invalid(field: let field, value: let value):
      return "A piece of data was not recognized <\(field): \(value)>"
    case .unknown:
      return "The cause of the failure is unknown"
    }
  }
}

internal struct UnknownErrorCode: Error {
  let code: String
  
  init?(code: String?) {
    guard let code = code else { return nil }
    
    self.code = code
  }
}
