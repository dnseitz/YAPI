//
//  NetworkMockObjects.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
@testable import YAPI

class MockURLSession: URLSessionProtocol {
  var nextData: NSData?
  var nextError: NSError?
  var nextDataTask = MockURLSessionDataTask()
  private(set) var lastURL: NSURL?
  
  func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
    self.lastURL = url
    completionHandler(data: self.nextData, response: nil, error: self.nextError)
    return self.nextDataTask
  }
  
  func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
    self.lastURL = request.URL
    completionHandler(data: self.nextData, response: nil, error: self.nextError)
    return self.nextDataTask
  }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  private(set) var resumeWasCalled = false
  
  func resume() {
    resumeWasCalled = true
  }
}