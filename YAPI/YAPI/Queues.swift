//
//  Threads.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

let GlobalMainQueue: WorkQueue = SerialQueue(withQueue: dispatch_get_main_queue())

enum QueueType {
  case Serial
  case Concurrent
  case Unknown
}

enum QueuePriority {
  case High
  case Default
  case Low
  case Background
}

protocol WorkQueue {
  var queue: dispatch_queue_t { get }
  var name: String { get }
  var type: QueueType { get }
  var priority: QueuePriority { get }
  
  init(_ name: String?, priority: QueuePriority)
  
  func executeSync(block: dispatch_block_t)
  func executeAsync(block: dispatch_block_t)
  
  func executeBarrierSync(block: dispatch_block_t)
  func executeBarrierAsync(block: dispatch_block_t)
}

extension WorkQueue {
  /**
      Execute a block of code and wait for the block to finish before returning
   */
  func executeSync(block: dispatch_block_t) {
    dispatch_sync(self.queue, block)
  }
  
  /**
      Execute a block of code and return immediately, the block will be run in the background
   */
  func executeAsync(block: dispatch_block_t) {
    dispatch_async(self.queue, block)
  }
}

/**
    A SerialQueue object represents a dispatch queue used for concurrency in iOS. Each queue should be 
    given a unique name to distinguish it. Use this if you need to perform work asynchronously or if you 
    need to synchronize access to some shared data.
 */
final class SerialQueue: WorkQueue {
  
  static private var count: Int = 0
  
  /// The queue that this object owns
  let queue: dispatch_queue_t
  
  /// The identifying name of the queue
  let name: String
  
  /// The type of the queue, serial or concurrent
  var type: QueueType {
    return .Serial
  }
  
  /// The priority of the queue, higher priority queues run more often
  let priority: QueuePriority
  
  private init(withQueue queue: dispatch_queue_t) {
    self.queue = queue
    self.name = "Main"
    self.priority = .High
  }
  
  /**
      Initialize a new serial queue with the given name, type and priority
   
      - Parameters:
        - withQueueName: The name used to identify the queue
        - withPriority: The priority that the queue should be set to
   */
  required init(_ name: String? = nil, priority: QueuePriority = .Default) {
    let queueName = name ?? "CRSerialQueue\(SerialQueue.count += 1)"
    let data = queueName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    let typeAttr: dispatch_queue_attr_t? = DISPATCH_QUEUE_SERIAL
    let queueAttr: dispatch_qos_class_t
    switch priority {
    case .High:
      queueAttr = QOS_CLASS_USER_INITIATED
      break
    case .Default:
      queueAttr = QOS_CLASS_USER_INTERACTIVE
      break
    case .Low:
      queueAttr = QOS_CLASS_UTILITY
      break
    case .Background:
      queueAttr = QOS_CLASS_BACKGROUND
      break
    }
    let attr = dispatch_queue_attr_make_with_qos_class(typeAttr, queueAttr, 0)
    self.queue = dispatch_queue_create(UnsafePointer(data.bytes), attr)
    self.name = queueName
    self.priority = priority
  }
  
  func executeBarrierSync(block: dispatch_block_t) {
    self.executeSync(block)
  }
  
  func executeBarrierAsync(block: dispatch_block_t) {
    self.executeAsync(block)
  }
}

final class ConcurrentQueue: WorkQueue {
  static private var count = 0
  
  /// The queue that this object owns
  let queue: dispatch_queue_t
  
  /// The identifying name of the queue
  let name: String
  
  /// The type of the queue, serial or concurrent
  var type: QueueType {
    return .Concurrent
  }
  
  /// The priority of the queue, higher priority queues run more often
  let priority: QueuePriority
  
  /**
      Initialize a new concurrent queue with the given name, type and priority
   
      - Parameters:
        - name: The name used to identify the queue
        - priority: The priority that the queue should be set to
   */
  required init(_ name: String? = nil, priority: QueuePriority = .Default) {
    let queueName = name ?? "CRConcurrentQueue\(ConcurrentQueue.count += 1)"
    let data = queueName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    let typeAttr: dispatch_queue_attr_t? = DISPATCH_QUEUE_CONCURRENT
    let queueAttr: dispatch_qos_class_t
    switch priority {
    case .High:
      queueAttr = QOS_CLASS_USER_INITIATED
      break
    case .Default:
      queueAttr = QOS_CLASS_USER_INTERACTIVE
      break
    case .Low:
      queueAttr = QOS_CLASS_UTILITY
      break
    case .Background:
      queueAttr = QOS_CLASS_BACKGROUND
      break
    }
    let attr = dispatch_queue_attr_make_with_qos_class(typeAttr, queueAttr, 0)
    self.queue = dispatch_queue_create(UnsafePointer(data.bytes), attr)
    self.name = queueName
    self.priority = priority
  }
  
  func executeBarrierSync(block: dispatch_block_t) {
    dispatch_barrier_sync(self.queue, block)
  }
  
  func executeBarrierAsync(block: dispatch_block_t) {
    dispatch_barrier_async(self.queue, block)
  }
}