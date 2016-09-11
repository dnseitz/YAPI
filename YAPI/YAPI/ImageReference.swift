//
//  ImageLoader.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/28/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import UIKit

final class ImageCache {
  static let globalCache = ImageCache()
  
  private var imageCache = [String: ImageReference]()
  private let cacheAccessQueue = ConcurrentQueue("CacheAccess", priority: .High)
  
  private init() {}
  
  private subscript(key: String) -> ImageReference? {
    get {
      var imageReference: ImageReference? = nil
      self.readLock() {
        imageReference = self.imageCache[key]
      }
      return imageReference
    }
    set {
      guard let imageReference = newValue else {
        return
      }
      self.writeLock() {
        self.imageCache[key] = imageReference
      }
    }
  }
  
  /**
      Flush all images in the cache
   */
  func flush() {
    self.writeLock() {
      self.imageCache.removeAll()
    }
  }

  /**
      Check if an image for a given url is stored in the cache
   
      - Parameter url: The url to check for
   
      - Returns: true if the image is in the cache, false if it is not
   */
  func contains(url: NSURL) -> Bool {
    return self[url.absoluteString] != nil
  }
  
  /**
      Check if an image for a given image reference is stored in the cache
   
      - Parameter imageReference: The image reference to check for
   
      - Returns: true if the image is in the cache, false if it is not
   */
  func contains(imageReference: ImageReference) -> Bool {
    return self[imageReference.url.absoluteString] != nil
  }
  
  private func readLock(block: dispatch_block_t) {
    self.cacheAccessQueue.executeSync(block)
  }
  
  private func writeLock(block: dispatch_block_t) {
    self.cacheAccessQueue.executeBarrierSync(block)
  }
  
}

/**
    A class representing an image retrieved from a network source. After being loaded an ImageReference 
    instance will contain a cachedImage property that allows you to access a copy of the image that was 
    loaded from the network source.
 
    It's less safe to use this cachedImage property than it is to just load the ImageReference again 
    through an image loader, so it is preferred to load and use the image returned by that. Be aware that 
    every time you access a cached image either through a load or the cachedImage property you are 
    recieving a **copy**, so each image can be scaled or modified independently of any others if they need 
    to be used more than once.
 
    - Usage:
    ```
      let imageReference = ImageReference(withURL: NSURL("some.image.com/path/to/image.jpg"))
 
      // This is an asynchronous operation, don't expect to have the cached image 
      // available after calling this
      imageReference.load() { (image, error) in 
        // Do something with the image here
      }
 
      imageReference.cachedImage // COULD BE NIL HERE EVEN IF THE IMAGE WILL BE SUCCESSFULLY LOADED
    ```
 */
final class ImageReference {
  
  private enum State {
    case Idle
    case Loading
  }
  private var state: ImageReference.State
  
  private let session: YelpHTTPClient
  
  private var _cachedImage: UIImage?
  /// A copy of the cached image or nil if no image has been loaded yet
  private(set) var cachedImage: UIImage? {
    get {
      guard let imageCopy = CGImageCreateCopy(self._cachedImage?.CGImage) else {
        return nil
      }
      return UIImage(CGImage: imageCopy)
    }
    set {
      if self._cachedImage == nil {
        self._cachedImage = newValue
      }
    }
  }
  
  let url: NSURL
  
  /**
      Initialize a new ImageReference with the specified url. Two ImageReferences initialized with the same
      url will functionally be the same image reference.
   
      - Parameter url: The url to retrieve the image from
      - Parameter session: The session to use to make network requests, generally keep this as default
   
      - Returns: An ImageLoader that is ready to load an image from the url
   */
  init(from url: NSURL, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    self.url = url
    self.state = .Idle
    self.session = session
  }
  
  /**
      Load an image in the background and pass it to the completion handler once finished. This can be 
      called multiple times to retrieve the same image at different scales. Only one load is allowed to be 
      in progress at a time. Each call will return a new instance of a UIImage
   
      - Parameter scale: The scale factor to apply to the image
      - Parameter completionHandler: The handler to call once the image load has completed. This handler 
          takes a UIImage? and a ImageLoaderError? as arguments. If the load was a success, the handler 
          will be called with the UIImage created and the error will be nil. If there is an error, the 
          image will be nil and an error object will be returned
   */
  func load(withScale scale: CGFloat = 1.0, completionHandler handler: (image: UIImage?, error: ImageLoadError?) -> Void) {
    if self.state == .Loading {
      GlobalMainQueue.executeAsync() {
        handler(image: nil, error: .LoadInProgress)
      }
      return
    }
    self.state = .Loading
    if let imageReference = ImageCache.globalCache[self.url.absoluteString] {
      self.cachedImage = imageReference.cachedImage
    }
    if let image = self.cachedImage {
      guard let imageCopy = CGImageCreateCopy(image.CGImage) else {
        GlobalMainQueue.executeAsync() {
          handler(image: nil, error: .CopyError)
        }
        return
      }
      GlobalMainQueue.executeAsync() {
        handler(image: UIImage(CGImage: imageCopy, scale: scale, orientation: image.imageOrientation), error: nil)
      }
      self.state = .Idle
      return
    }
    
    self.session.send(self.url) {(data, response, error) in
      let imageResult: UIImage?
      let errorResult: ImageLoadError?
      defer {
        self.state = .Idle
        GlobalMainQueue.executeAsync() {
          handler(image: imageResult, error: errorResult)
        }
      }
      if let err = error {
        imageResult = nil
        errorResult = .RequestError(err)
        return
      }

      guard let imageData = data else {
        imageResult = nil
        errorResult = .NoDataRecieved
        return
      }
      
      guard let image = UIImage(data: imageData) else {
        imageResult = nil
        errorResult = .InvalidData
        return
      }
      
      self.cachedImage = image
      ImageCache.globalCache[self.url.absoluteString] = self
      imageResult = UIImage(data: imageData, scale: scale)
      errorResult = nil
    }
  }
  
}


enum ImageLoadError: ErrorType, Equatable {
  /// An error occurred when trying to send the request, check the wrapped NSError object for more details
  case RequestError(NSError)
  /// No data was recieved when trying to load the image
  case NoDataRecieved
  /// Data was recieved, but it was not an image
  case InvalidData
  /// A load is currently in progress, wait for that to finish
  case LoadInProgress
  /// Failed to create a valid copy of the cached image
  case CopyError
}

func ==(lhs: ImageLoadError, rhs: ImageLoadError) -> Bool {
  switch (lhs, rhs) {
  case (let .RequestError(err1), let .RequestError(err2)):
    return err1.domain == err2.domain && err1.code == err2.code
  case (.NoDataRecieved, .NoDataRecieved):
    return true
  case (.InvalidData, .InvalidData):
    return true
  case (.LoadInProgress, .LoadInProgress):
    return true
  case (.CopyError, .CopyError):
    return true
  default:
    return false
  }
}