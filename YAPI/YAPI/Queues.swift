////
////  Threads.swift
////  Chowroulette
////
////  Created by Daniel Seitz on 7/29/16.
////  Copyright © 2016 Daniel Seitz. All rights reserved.
////
//
//import Foundation
//
//let GlobalMainQueue: WorkQueue = SerialQueue(withQueue: DispatchQueue.main)
//
//enum QueueType {
//  case serial
//  case concurrent
//  case unknown
//}
//
//enum QueuePriority {
//  case high
//  case `default`
//  case low
//  case background
//}
//
//protocol WorkQueue {
//  var queue: DispatchQueue { get }
//  var name: String { get }
//  var type: QueueType { get }
//  var priority: QueuePriority { get }
//  
//  init(_ name: String?, priority: QueuePriority)
//  
//  func executeSync(_ block: ()->())
//  func executeAsync(_ block: ()->())
//  
//  func executeBarrierSync(_ block: ()->())
//  func executeBarrierAsync(_ block: ()->())
//}
//
//extension WorkQueue {
//  /**
//      Execute a block of code and wait for the block to finish before returning
//   */
//  func executeSync(_ block: ()->()) {
//    self.queue.sync(execute: block)
//  }
//  
//  /**
//      Execute a block of code and return immediately, the block will be run in the background
//   */
//  func executeAsync(_ block: @escaping ()->()) {
//    self.queue.async(execute: block)
//  }
//}
//
///**
//    A SerialQueue object represents a dispatch queue used for concurrency in iOS. Each queue should be 
//    given a unique name to distinguish it. Use this if you need to perform work asynchronously or if you 
//    need to synchronize access to some shared data.
// */
//final class SerialQueue: WorkQueue {
//  
//  static fileprivate var count: Int = 0
//  
//  /// The queue that this object owns
//  let queue: DispatchQueue
//  
//  /// The identifying name of the queue
//  let name: String
//  
//  /// The type of the queue, serial or concurrent
//  var type: QueueType {
//    return .serial
//  }
//  
//  /// The priority of the queue, higher priority queues run more often
//  let priority: QueuePriority
//  
//  fileprivate init(withQueue queue: DispatchQueue) {
//    self.queue = queue
//    self.name = "Main"
//    self.priority = .high
//  }
//  
//  /**
//      Initialize a new serial queue with the given name, type and priority
//   
//      - Parameters:
//        - withQueueName: The name used to identify the queue
//        - withPriority: The priority that the queue should be set to
//   */
//  required init(_ name: String? = nil, priority: QueuePriority = .default) {
//    let queueName = name ?? "CRSerialQueue\(SerialQueue.count += 1)"
//    let data = queueName.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//    let typeAttr: DispatchQueue.Attributes? = DispatchQueue.Attributes()
//    let queueAttr: DispatchQoS.QoSClass
//    switch priority {
//    case .high:
//      queueAttr = DispatchQoS.QoSClass.userInitiated
//      break
//    case .default:
//      queueAttr = DispatchQoS.QoSClass.userInteractive
//      break
//    case .low:
//      queueAttr = DispatchQoS.QoSClass.utility
//      break
//    case .background:
//      queueAttr = DispatchQoS.QoSClass.background
//      break
//    }
//    let attr = dispatch_queue_attr_make_with_qos_class(typeAttr, queueAttr, 0)
//    self.queue = DispatchQueue(label: (data as NSData).bytes.bindMemory(to: Int8.self, capacity: data.count), attributes: attr)
//    self.name = queueName
//    self.priority = priority
//  }
//  
//  func executeBarrierSync(_ block: ()->()) {
//    self.executeSync(block)
//  }
//  
//  func executeBarrierAsync(_ block: @escaping ()->()) {
//    self.executeAsync(block)
//  }
//}
//
//final class ConcurrentQueue: WorkQueue {
//  static fileprivate var count = 0
//  
//  /// The queue that this object owns
//  let queue: DispatchQueue
//  
//  /// The identifying name of the queue
//  let name: String
//  
//  /// The type of the queue, serial or concurrent
//  var type: QueueType {
//    return .concurrent
//  }
//  
//  /// The priority of the queue, higher priority queues run more often
//  let priority: QueuePriority
//  
//  /**
//      Initialize a new concurrent queue with the given name, type and priority
//   
//      - Parameters:
//        - name: The name used to identify the queue
//        - priority: The priority that the queue should be set to
//   */
//  required init(_ name: String? = nil, priority: QueuePriority = .default) {
//    let queueName = name ?? "CRConcurrentQueue\(ConcurrentQueue.count += 1)"
//    let data = queueName.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//    let typeAttr: DispatchQueue.Attributes? = DispatchQueue.Attributes.concurrent
//    let queueAttr: DispatchQoS.QoSClass
//    switch priority {
//    case .high:
//      queueAttr = DispatchQoS.QoSClass.userInitiated
//      break
//    case .default:
//      queueAttr = DispatchQoS.QoSClass.userInteractive
//      break
//    case .low:
//      queueAttr = DispatchQoS.QoSClass.utility
//      break
//    case .background:
//      queueAttr = DispatchQoS.QoSClass.background
//      break
//    }
//    let attr = dispatch_queue_attr_make_with_qos_class(typeAttr, queueAttr, 0)
//    self.queue = DispatchQueue(label: (data as NSData).bytes.bindMemory(to: Int8.self, capacity: data.count), attributes: attr)
//    self.name = queueName
//    self.priority = priority
//  }
//  
//  func executeBarrierSync(_ block: ()->()) {
//    self.queue.sync(flags: .barrier, execute: block)
//  }
//  
//  func executeBarrierAsync(_ block: @escaping ()->()) {
//    self.queue.async(flags: .barrier, execute: block)
//  }
//}
