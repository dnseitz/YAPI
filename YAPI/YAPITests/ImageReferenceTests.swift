//
//  ImageReferenceTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class ImageReferenceTests: YAPIXCTestCase {
  
  var session: YelpHTTPClient!
  let mockSession = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    session = YelpHTTPClient(session: mockSession)
  }
  
  override func tearDown() {
    ImageCache.globalCache.flush()
    
    mockSession.nextData = nil
    mockSession.nextError = nil
    
    super.tearDown()
  }
  
  func test_LoadImage_LoadsAnImageFromValidData() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    imageReference.load() { (image, error) -> Void in
      XCTAssertNotNil(image)
      XCTAssertNil(error)
    }
  }
  
  func test_LoadImage_LoadsAnImageFromValidData_CachesTheImage() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    imageReference.load() { (image, error) -> Void in }
    let imageReference2 = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    imageReference2.load() { (image, error) -> Void in }
    XCTAssertNotNil(imageReference.cachedImage)
    XCTAssertNotNil(imageReference2.cachedImage)
  }
  
  func test_LoadImage_LoadsAnImageFromInvalidData_GivesAnError() {
    mockSession.nextData = Data()
    let imageReference = ImageReference(from: URL(fileURLWithPath: ""), session: session)
    imageReference.load() { (image, error) -> Void in
      XCTAssertNil(image)
      XCTAssertNotNil(error)
      
      XCTAssert(error! == .invalidData)
    }
  }
  
  func test_LoadImage_WhereRequestErrors_GivesTheError() {
    let mockError = NSError(domain: "error", code: 0, userInfo: nil)
    mockSession.nextError = mockError
    let imageReference = ImageReference(from: URL(fileURLWithPath: ""), session: session)
    imageReference.load() { (image, error) -> Void in
      XCTAssertNil(image)
      XCTAssertNotNil(error)
      
      XCTAssert(error! == .requestError(mockError))
    }
  }
  
  func test_LoadImage_RecievesNoData_GivesAnError() {
    let imageReference = ImageReference(from: URL(fileURLWithPath: ""), session: session)
    imageReference.load() { (image, error) -> Void in
      XCTAssertNil(image)
      XCTAssertNotNil(error)
      
      XCTAssert(error! == .noDataRecieved)
    }
  }
  
  func test_LoadImage_WithDifferentImageReferencesToSameURL_GivesCachedImage() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    let imageReference2 = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load() { (image, error) -> Void in
      imageReference2.load() { (image2, error2) -> Void in
        XCTAssertNotNil(image)
        XCTAssertNil(error)
        XCTAssertNotNil(image2)
        XCTAssertNil(error2)
        
        let imageData = UIImagePNGRepresentation(image!)!
        let imageData2 = UIImagePNGRepresentation(image2!)!
        let cachedImageData = UIImagePNGRepresentation(imageReference.cachedImage!)!
        let cachedImageData2 = UIImagePNGRepresentation(imageReference2.cachedImage!)!
        
        XCTAssert(imageReference.cachedImage !== image)
        XCTAssert(imageReference.cachedImage !== image2)
        XCTAssert(cachedImageData == imageData)
        XCTAssert(cachedImageData == imageData2)
        XCTAssert(imageReference2.cachedImage !== image)
        XCTAssert(imageReference2.cachedImage !== image2)
        XCTAssert(cachedImageData2 == imageData)
        XCTAssert(cachedImageData2 == imageData2)
        XCTAssert(image !== image2)
        XCTAssert(imageData == imageData2)
        
        XCTAssert(imageReference.cachedImage !== imageReference2.cachedImage)
      }
    }
  }
  
  func test_FlushCache_RemovesAllImagesFromTheCache() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let url = URL(string: "http://s3-media3.fl.yelpcdn.com/asdf.jpg")!
    let url2 = URL(string: "http://s3-media3.fl.yelpcdn.com/qwer.jpg")!
    let imageReference = ImageReference(from: url, session: session)
    let imageReference2 = ImageReference(from: url2, session: session)
    
    imageReference.load() { (image, error) -> Void in
      imageReference2.load() { (image2, error2) -> Void in
        XCTAssertNotNil(image)
        XCTAssertNil(error)
        XCTAssertNotNil(image2)
        XCTAssertNil(error2)
        
        XCTAssert(ImageCache.globalCache.contains(url) == true)
        XCTAssert(ImageCache.globalCache.contains(url2) == true)
        
        ImageCache.globalCache.flush()
        
        XCTAssert(ImageCache.globalCache.contains(url) == false)
        XCTAssert(ImageCache.globalCache.contains(url2) == false)
      }
    }
  }
  
  func test_CachedImageProperty_ReturnsCopy() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load() { (image, error) -> Void in
      let cachedImage = imageReference.cachedImage
      
      XCTAssertNotNil(cachedImage)
      XCTAssertNotNil(image)
      XCTAssertNil(error)
      
      // These seem wierd, but we're asserting that the cachedImage property is returning copies of the 
      // image, not the same reference
      XCTAssert(cachedImage !== image)
      XCTAssert(cachedImage !== imageReference.cachedImage)
      XCTAssert(imageReference.cachedImage !== imageReference.cachedImage)
    }
  }
  
  func test_LoadImageWithScale_ScalesTheImage() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load(withScale: 0.5) { (image, error) -> Void in
      XCTAssertNotNil(image)
      XCTAssertNil(error)
      
      XCTAssert(image!.scale == 0.5)
    }
    
    imageReference.load(withScale: 1.5) { (image, error) -> Void in
      XCTAssertNotNil(image)
      XCTAssertNil(error)
      
      XCTAssert(image!.scale == 1.5)
    }
  }
}
