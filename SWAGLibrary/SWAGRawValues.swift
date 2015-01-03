//
//  SWAGRawValues.swift
//  SWAGLibrary
//
//  Created by Yose on 12/25/14.
//  Copyright (c) 2014 Yose. All rights reserved.
//

import UIKit

class SWAGRawValues: NSObject {
   
    class Singleton {
        

        
        class var sharedInstance : Singleton {
            struct Static {
                static let instance : Singleton = Singleton()
            }
            return Static.instance
        }
    }
    
    

    
    struct ServerValues {

        static var bookCount: Int = 0
        static var author: String = ""
        static var lastCheckedOut: String? = ""
        static var lastCheckedOutBy: String? = ""
        static var publisher: String = ""
        static var title: String = ""
        static var tags: String = ""
        static var url: NSURL = NSURL()
        static var error: String = ""
        static var id: Int = Int()
    }
    
    struct BookValues {
        static var bookCount: Int = Int()
        static var author: String = ""
        static var lastCheckedOut: String? = ""
        static var lastCheckedOutBy: String? = ""
        static var publisher: String = ""
        static var title: String = ""
        static var tags: String = ""
        static var id: Int = Int()
    }
    
   
    enum Errors:String
    {
        case General = "An error has occurred"
        case DeleteAllBooks = "An error occurred trying to delete all the books"
        case DeletedBook = "An error occurred deleting this book"
        case CheckingOutBook = "An error occurred checking out this book"
        case CreatingBook = "An error occurred creating this book"
    }
    
    
    
}

class GCDDispatch: NSObject {
    class func after(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
