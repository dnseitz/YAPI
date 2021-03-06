//
//  ResultTests.swift
//  YAPITests
//
//  Created by Daniel Seitz on 11/11/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class ResultTests: XCTestCase {
  
  func test_Result_isOk() {
    let x: Result<Int, String> = .ok(1)
    XCTAssert(x.isOk())
    
    let y: Result<Int, String> = .err("Oops")
    XCTAssertFalse(y.isOk())
  }
  
  func test_Result_isErr() {
    let x: Result<Int, String> = .ok(1)
    XCTAssertFalse(x.isErr())
    
    let y: Result<Int, String> = .err("Oops")
    XCTAssert(y.isErr())
  }
  
  func test_Result_makeOk() {
    let x: Result<Int, String> = .ok(1)
    XCTAssertEqual(x.intoOk(), 1)
    
    let y: Result<Int, String> = .err("Oops")
    XCTAssertNil(y.intoOk())
  }
  
  func test_Result_makeErr() {
    let x: Result<Int, String> = .ok(1)
    XCTAssertNil(x.intoErr())
    
    let y: Result<Int, String> = .err("Oops")
    XCTAssertEqual(y.intoErr(), "Oops")
  }
  
  func test_Result_map() {
    let x: Result<Int, String> = .ok(5)
    XCTAssertEqual(x.map({ $0 * 2 }).intoOk(), 10)
  }
  
  func test_Result_mapErr() {
    let x: Result<Int, String> = .err("Hello")
    XCTAssertEqual(x.mapErr({ "\($0), World" }).intoErr(), "Hello, World")
  }
  
  func test_Result_and() {
    let x1: Result<Int, String> = .ok(2)
    let y1: Result<String, String> = .err("late error")
    XCTAssertEqual(x1.and(y1).intoErr(), "late error")
    
    let x2: Result<Int, String> = .err("early error")
    let y2: Result<String, String> = .ok("foo")
    XCTAssertEqual(x2.and(y2).intoErr(), "early error")
    
    let x3: Result<Int, String> = .err("early error")
    let y3: Result<String, String> = .err("late error")
    XCTAssertEqual(x3.and(y3).intoErr(), "early error")
    
    let x4: Result<Int, String> = .ok(2)
    let y4: Result<String, String> = .ok("different result type")
    XCTAssertEqual(x4.and(y4).intoOk(), "different result type")
  }
  
  func test_Result_andThen() {
    let sq: (Int) -> Result<Int, Int> = { .ok($0 * $0) }
    let err: (Int) -> Result<Int, Int> = { .err($0) }
    let ok: Result<Int, Int> = .ok(2)
    let error: Result<Int, Int> = .err(3)
    
    XCTAssertEqual(ok.andThen(sq).andThen(sq).intoOk(), 16)
    XCTAssertEqual(ok.andThen(sq).andThen(err).intoErr(), 4)
    XCTAssertEqual(ok.andThen(err).andThen(sq).intoErr(), 2)
    XCTAssertEqual(error.andThen(sq).andThen(sq).intoErr(), 3)
  }
  
  func test_Result_or() {
    let x1: Result<Int, String> = .ok(2)
    let y1: Result<Int, String> = .err("late error")
    XCTAssertEqual(x1.or(y1).intoOk(), 2)
    
    let x2: Result<Int, String> = .err("early error")
    let y2: Result<Int, String> = .ok(2)
    XCTAssertEqual(x2.or(y2).intoOk(), 2)
    
    let x3: Result<Int, String> = .err("early error")
    let y3: Result<Int, String> = .err("late error")
    XCTAssertEqual(x3.or(y3).intoErr(), "late error")
    
    let x4: Result<Int, String> = .ok(2)
    let y4: Result<Int, String> = .ok(100)
    XCTAssertEqual(x4.or(y4).intoOk(), 2)
  }
  
  func test_Result_orElse() {
    let sq: (Int) -> Result<Int, Int> = { .ok($0 * $0) }
    let err: (Int) -> Result<Int, Int> = { .err($0) }
    let ok: Result<Int, Int> = .ok(2)
    let error: Result<Int, Int> = .err(3)
    
    XCTAssertEqual(ok.orElse(sq).orElse(sq).intoOk(), 2)
    XCTAssertEqual(ok.orElse(err).orElse(sq).intoOk(), 2)
    XCTAssertEqual(error.orElse(sq).orElse(err).intoOk(), 9)
    XCTAssertEqual(error.orElse(err).orElse(err).intoErr(), 3)
  }
}

