//
//  SWAGBookRetrieval.swift
//  SWAGLibrary
//
//  Created by Yose on 12/25/14.
//  Copyright (c) 2014 Yose. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class SWAGBookRetrieval: NSObject {
   
    enum Server:String
    {
        case URL = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/"
        case URLBook1 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/1"
        case URLBook2 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/2"
        case URLBook3 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/3"
        case URLBook4 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/4"
        case URLBook5 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/5"
        case URLBook6 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/6"
        case URLBook7 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/7"
        case URLBook8 = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/8"
    }
 
    // Arrays that will hold the data source for tableview
    
    struct ArraysOf {
        static var authors: [String] = []
        static var title: [String] = []
        static var publisher: [String] = []
        static var lastCheckedOutBy: [String] = []
    }
    
    
   
    //  Retrieval of all books
    
    class func retrieveAllBooks()
    {
          let serverURL = "http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/2"
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        request.GET(serverURL, parameters: nil, success: { (response: HTTPResponse) in
            
            //            if the response object is valid
            
            if response.responseObject != nil
            {
                
                let objectCount = (response.responseObject as NSDictionary).count
                println("The object count is \(objectCount)")
                
                println("The book information is \(response.responseObject)")
                let author: AnyObject? = (response.responseObject as NSDictionary).valueForKey("author")
                println("Our author returned: \((author as String))")
                
                
                
            }
            }) { (error: NSError, response: HTTPResponse?) in
                println("Oops, you received an error: \(error)")
        }

    }
    
    
    
    class func numberOfBooks()
    {
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        request.GET(Server.URL.rawValue, parameters: nil, success: { (response: HTTPResponse) -> Void in
            
            
            if response.responseObject != nil
            {
                let objectCount = (response.responseObject as NSArray).count

                let SWGRV = SWAGRawValues()
                SWAGRawValues.ServerValues.bookCount = objectCount
                

            }
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
            
                if error == true
                {
                    println("An error occurred retrieving the authors for the books. - \(error.localizedDescription)")
                }
                
        }
        


    }
    
    class func authorForBooks()
    {
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        request.GET(Server.URL.rawValue, parameters: nil, success: { (response: HTTPResponse) -> Void in
            
            if response.responseObject != nil
            {
                let books = (response.responseObject as NSArray)

                let book1: AnyObject = books.objectAtIndex(0)

                let authorName1: String = ((book1 as NSDictionary).valueForKey("author") as String)

                
                let book2: AnyObject = books.objectAtIndex(1)
                 /*
                fast enumerate through the books to grab the authors and put them
                into the array that will propogate the datasource array of the tableview

                */
                for (var book: AnyObject) in books
                {
                    var author: String = ((book as NSDictionary).valueForKey("author") as String)
//                    println("The current author is \(author)")
                    ArraysOf.authors.append(author)
                    var title: String = ((book as NSDictionary).valueForKey("title") as String)
                    ArraysOf.title.append(title)
                    
                }
                
//                println("The number of authors are \(ArraysOf.authors.count)")fd
                
            }
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
            
                if error == true
                {
                    println("An error occurred retrieving the authors for the books. - \(error.localizedDescription)")
                }
        }
        
        
        
    }
    
}
