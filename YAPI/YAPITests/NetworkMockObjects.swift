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
  var nextData: Data?
  var nextError: NSError?
  var nextDataTask = MockURLSessionDataTask()
  fileprivate(set) var lastURL: URL?
  
  func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    self.lastURL = url
    completionHandler(self.nextData, nil, self.nextError)
    return self.nextDataTask
  }
  
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    self.lastURL = request.url
    completionHandler(self.nextData, nil, self.nextError)
    return self.nextDataTask
  }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  fileprivate(set) var resumeWasCalled = false
  
  func resume() {
    resumeWasCalled = true
  }
}
