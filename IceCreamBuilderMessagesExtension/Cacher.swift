//
//  Cacher.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by lorne on 10/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

public class Cache : NSCache<NSString, NSString> {
    public static var sharedInstance = NSCache<NSString,NSString>()
    
}
public protocol Cachable {
    var fileName: String { get }
    func transform() -> Data
}

//TODO POSSBILE DELETE
final public class Cacher {
    let destination: URL
    private let queue = OperationQueue()
    
    public enum CacheDestination {
        case temporary
        case atFolder(String)
    }
    
    // MARK: Initialization
    public init(destination: CacheDestination) {
        // Create the URL for the location of the cache resources
        switch destination {
        case .temporary:
            self.destination = URL(fileURLWithPath: NSTemporaryDirectory())
        case .atFolder(let folder):
            let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            self.destination = URL(fileURLWithPath: documentFolder).appendingPathComponent(folder, isDirectory: true)
        }
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(at: self.destination, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            fatalError("Unable to create cache URL: \(error)")
        }
    }
    
    // MARK
    public func persist(item: Cachable, completion: @escaping (_ url: URL) -> Void) {
        let url = destination.appendingPathComponent(item.fileName, isDirectory: false)
        
        // Create an operation to process the request.
        let operation = BlockOperation {
            do {
                try item.transform().write(to: url, options: [.atomicWrite])
            } catch {
                fatalError("Failed to write item to cache: \(error)")
            }
        }
        
        // Set the operation's completion block to call the request's completion handler.
        operation.completionBlock = {
            completion(url)
        }
        
        // Add the operation to the queue to start the work.
        queue.addOperation(operation)
    }
}
