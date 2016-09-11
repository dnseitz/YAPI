//
//  YelpHTTPClient.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

typealias DataTaskResult = (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void

protocol URLSessionProtocol {
  func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
  func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
}
extension NSURLSession: URLSessionProtocol {
  func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
    return (self.dataTaskWithURL(url, completionHandler: completionHandler) as NSURLSessionDataTask) as URLSessionDataTaskProtocol
  }
  
  func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
    return (self.dataTaskWithRequest(request, completionHandler: completionHandler) as NSURLSessionDataTask) as URLSessionDataTaskProtocol
  }
}

protocol URLSessionDataTaskProtocol {
  func resume()
}
extension NSURLSessionDataTask: URLSessionDataTaskProtocol {}

public final class YelpHTTPClient {
  static let sharedSession = YelpHTTPClient()
  private let session: URLSessionProtocol
  
  /**
      Initialize a new YelpHTTPClient with the session to use for network requests
   
      - Parameter session: The session object to use to make network requests
   */
  init(session: URLSessionProtocol = NSURLSession.sharedSession()) {
    self.session = session
  }
  
  /**
      Send a request to the specified url.
   
      - Parameter url: The url to request from
      - Parameter completionHandler: The handler to call with the response information
   */
  func send(url: NSURL, completionHandler handler: DataTaskResult) {
    let task = self.session.dataTaskWithURL(url, completionHandler: handler)
    task.resume()
  }
  
  /**
      Send a request using the specified NSURLRequest object
   
      - Parameter request: The request object to request information with
      - Parameter completionHandler: The handler to call with the response information
   */
  func send(request: NSURLRequest, completionHandler handler: DataTaskResult) {
    let task = self.session.dataTaskWithRequest(request, completionHandler: handler)
    task.resume()
  }
}

