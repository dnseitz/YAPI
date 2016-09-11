//
//  QueuesTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/31/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class QueuesTests: YAPIXCTestCase {
  
  func test_SerialQueue_ExecutesBlocksInOrder() {
    let queue = SerialQueue("TESTSERIAL", priority: .High)
    var count: Int = 0
    
    queue.executeAsync() {
      XCTAssert(count == 0)
      count += 1
    }
    queue.executeAsync() {
      XCTAssert(count == 1)
      count += 1
    }
    queue.executeSync() {
      XCTAssert(count == 2)
      count += 1
    }
    XCTAssert(count == 3)
  }
  
  func test_ConcurrentQueue_ExecuteBarrier_BlocksUntilAllJobsAreDone() {
    var flag: Bool = false
    let queue = ConcurrentQueue("TESTCONCURRENT", priority: .High)
    let block: dispatch_block_t = { flag = true }
    
    queue.executeAsync(block)
    queue.executeBarrierSync() {
      XCTAssert(flag == true)
    }
      
    flag = false
      
    queue.executeAsync(block)
    queue.executeBarrierAsync() {
      usleep(100)
    }
    queue.executeSync() {
      XCTAssert(flag == true)
    }
  }
  
  func test_ConcurrentQueue_ExecuteSync_BlocksUntilJobComplete() {
    var flag: Bool = false
    let queue = ConcurrentQueue("TESTCONCURRENT", priority: .High)
    
    queue.executeSync() {
      flag = true
    }
    queue.executeSync() {
      XCTAssert(flag == true)
    }
  }
}
