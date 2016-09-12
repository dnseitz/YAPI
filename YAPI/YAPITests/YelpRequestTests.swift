//
//  YelpRequestTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpRequestTests: YAPIXCTestCase {
  
  var session: YelpHTTPClient!
  var request: YelpRequest!
  let mockSession = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    session = YelpHTTPClient(session: mockSession)
    request = YelpSearchRequest(search: YelpSearchParameters(location: "Portland, OR" as YelpSearchLocation), session: session)
  }
  
  override func tearDown() {
    mockSession.nextData = nil
    mockSession.nextError = nil
    
    super.tearDown()
  }
  
  func test_SendRequest_RecievesData_ParsesTheData() {
    mockSession.nextData = NSData(base64EncodedString: ResponseInjections.yelpValidOneBusinessResponse, options: .IgnoreUnknownCharacters)
    request.send() { (response, error) in
      XCTAssertNotNil(response)
      XCTAssertNil(error)
      
      let business = response!.businesses[0]
      
      XCTAssert(business.categories.count == 2)
      
      XCTAssertNotNil(business.displayPhoneNumber)
      XCTAssert(business.displayPhoneNumber! == "+1-415-908-3801")
      
      XCTAssert(business.id == "yelp-san-francisco")
      
      XCTAssertNotNil(business.image)
      XCTAssert(business.image!.url.absoluteString == "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")
      
      XCTAssert(business.claimed == true)
      
      XCTAssert(business.closed == false)
      
      XCTAssert(business.location.address.count == 1)
      XCTAssert(business.location.address[0] == "140 New Montgomery St")
      XCTAssert(business.location.city == "San Francisco")
      XCTAssertNotNil(business.location.coordinate)
      XCTAssert(business.location.coordinate!.latitude == 37.7867703362929)
      XCTAssert(business.location.coordinate!.longitude == -122.399958372115)
      XCTAssert(business.location.countryCode == "US")
      XCTAssertNotNil(business.location.crossStreets)
      XCTAssert(business.location.crossStreets! == "Natoma St & Minna St")
      XCTAssert(business.location.displayAddress.count == 3)
      XCTAssert(business.location.geoAccuraccy == 9.5)
      XCTAssertNotNil(business.location.neighborhoods)
      XCTAssert(business.location.neighborhoods!.count == 2)
      XCTAssert(business.location.postalCode == "94105")
      XCTAssert(business.location.stateCode == "CA")
      
      XCTAssert(business.mobileURL.absoluteString == "http://m.yelp.com/biz/yelp-san-francisco")
      
      XCTAssert(business.name == "Yelp")
      
      XCTAssertNotNil(business.phoneNumber)
      XCTAssert(business.phoneNumber! == "4159083801")
      
      XCTAssert(business.rating.rating == 2.5)
      XCTAssert(business.rating.image.url.absoluteString == "http://s3-media4.fl.yelpcdn.com/assets/2/www/img/c7fb9aff59f9/ico/stars/v1/stars_2_half.png")
      XCTAssert(business.rating.largeImage.url.absoluteString == "http://s3-media2.fl.yelpcdn.com/assets/2/www/img/d63e3add9901/ico/stars/v1/stars_large_2_half.png")
      XCTAssert(business.rating.smallImage.url.absoluteString == "http://s3-media4.fl.yelpcdn.com/assets/2/www/img/8e8633e5f8f0/ico/stars/v1/stars_small_2_half.png")
      
      XCTAssert(business.reviewCount == 7140)
      
      XCTAssertNotNil(business.snippet.image)
      XCTAssert(business.snippet.image!.url.absoluteString == "http://s3-media4.fl.yelpcdn.com/photo/YcjPScwVxF05kj6zt10Fxw/ms.jpg")
      XCTAssertNotNil(business.snippet.text)
      XCTAssert(business.snippet.text! == "What would I do without Yelp?\n\nI wouldn't be HALF the foodie I've become it weren't for this business.    \n\nYelp makes it virtually effortless to discover new...")
      
      XCTAssert(business.url.absoluteString == "http://www.yelp.com/biz/yelp-san-francisco")
    }
  }
  
  func test_SendRequest_WhereRequestErrors_GivesTheError() {
    let mockError = NSError(domain: "error", code: 0, userInfo: nil)
    mockSession.nextError = mockError
    request.send() { (response, error) -> Void in
      XCTAssertNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(error as! YelpRequestError == .FailedToSendRequest(mockError))
    }
  }
  
  func test_SendRequest_RecievesNoData_GivesAnError() {
    request.send() { (response, error) -> Void in
      XCTAssertNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(error as! YelpResponseError == .NoDataRecieved)
    }
  }
  
  func test_SendRequest_RecievesBadData_GivesAnError() {
    mockSession.nextData = NSData()
    request.send() { (response, error) -> Void in
      XCTAssertNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(error as! YelpResponseError == .FailedToParse)
    }
  }
  
  func test_SendRequest_RecievesYelpError_GivesTheError() {
    mockSession.nextData = NSData(base64EncodedString: ResponseInjections.yelpErrorResponse, options: .IgnoreUnknownCharacters)
    request.send() { (response, error) -> Void in
      XCTAssertNotNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(response!.businesses.count == 0)
      XCTAssert((self.request as! AnyObject) === (response!.request as! AnyObject))
      XCTAssertNotNil(response!.error)
      XCTAssert(response!.error! == YelpResponseError.InvalidParameter(field: "location"))
      XCTAssert(response!.wasSuccessful == false)
      
      XCTAssert(response!.error == (error as! YelpResponseError))
    }
  }
}
