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
        static var bookID: [UInt] = []
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
        
//        ArraysOf.authors = [String]()
//        ArraysOf.bookID = [UInt]()
//        ArraysOf.lastCheckedOutBy = [String]()
//        ArraysOf.publisher = [String]()
//        ArraysOf.title = [String]()
        
//        empty sets of arrays that will hold the server values received
        
        var authors:[String] = [String]()
        var booktitles: [String] = [String]()
        var bookNumbers: [UInt] = [UInt]()
        

        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        request.GET(Server.URL.rawValue, parameters: nil, success: { (response: HTTPResponse) -> Void in
            
            
            
            
            if response.responseObject != nil
            {
                let books = (response.responseObject as NSArray)
                
//                use a sort descriptor to sort by ascending ID number (for tableview purposes)
                let idDescriptor = NSSortDescriptor(key: "id", ascending: true)
                
                let sortedBooks:NSArray = books.sortedArrayUsingDescriptors([idDescriptor])
                println("The sorted books are \(sortedBooks)")

                let book1: AnyObject = sortedBooks.objectAtIndex(0)
                println("The books are \(sortedBooks)")
                let authorName1: String = ((book1 as NSDictionary).valueForKey("author") as String)

                
                let book2: AnyObject = sortedBooks.objectAtIndex(1)
                 /*
                fast enumerate through the books to grab the authors and put them
                into the array that will propogate the datasource array of the tableview

                */
                for (var book: AnyObject) in sortedBooks
                {
                    let author: String = ((book as NSDictionary).valueForKey("author") as String)
//                    println("The current author is \(author)")
                    authors.append(author)
                    let title: String = ((book as NSDictionary).valueForKey("title") as String)
                    booktitles.append(title)
                    let ids: UInt = UInt(((book as NSDictionary).valueForKey("id") as Int))
                    bookNumbers.append(ids)
                  
                }
                
//               if books are already loaded into tableview, compare them
//                to new books if a refresh is called
//                if they aren't the same, replace old books with updated ones from server
                
                if (ArraysOf.title.count != booktitles.count)
                {
                    ArraysOf.title = booktitles
                    ArraysOf.authors = authors
                    ArraysOf.bookID = bookNumbers
                    
                }
                
                else if (ArraysOf.title.count == booktitles.count)
                {
                    println("No new books have been added or deleted")
                }
                
                println("The number of books are \(ArraysOf.title.count)")
            }
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
            
                if error == true
                {
                    println("An error occurred retrieving the authors for the books. - \(error.localizedDescription)")
                }
        }
        
        
        
    }
    
    class func retrieveASpecificBook(bookIndex: UInt)
    {
        
//        find out correct book to search for
        let bookNumber: UInt = bookIndex + 1
        let bookCharacter = String(bookNumber)
        
        
        let bookUrl: String = Server.URL.rawValue + bookCharacter
        
//        use newly constructed url to search for the given book
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        request.GET(bookUrl, parameters: nil, success: { (response: HTTPResponse) -> Void in
            
//            Once we have a valid server response, we assign our server struct values to the 
//            received book values
            if response.responseObject != nil
            {
                println("The server returned \(response.responseObject!)")
                
                let author = ((response.responseObject as NSDictionary).valueForKey("author") as String)
                let title = ((response.responseObject as NSDictionary).valueForKey("title") as String)
                let tags = ((response.responseObject as NSDictionary).valueForKey("categories") as String)
                let publisher = ((response.responseObject as NSDictionary).valueForKey("publisher") as? String)
                let lastCheckedOut = ((response.responseObject as NSDictionary).valueForKey("lastCheckedOut") as? String)
                let lastCheckedOutBy = ((response.responseObject as NSDictionary).valueForKey("lastCheckedOutBy") as? String)
                let id = ((response.responseObject as NSDictionary).valueForKey("id") as Int)
//                check if book has been checked out before
                
                
      
                
                switch lastCheckedOutBy
                {
                case nil:
                    println("Hasn't been checked out by anyone as of yet")
                    SWAGRawValues.ServerValues.lastCheckedOutBy = "Not yet checked out"
                    
                default:

                    SWAGRawValues.ServerValues.lastCheckedOutBy = lastCheckedOutBy!
                    println("Checked out by \(SWAGRawValues.ServerValues.lastCheckedOutBy)")
                }
                
                
                switch lastCheckedOut
                {
                case nil:
                    println("Book has never been checked out")
                    SWAGRawValues.ServerValues.lastCheckedOut = ""
                    
                default:

                    SWAGRawValues.ServerValues.lastCheckedOut = lastCheckedOut!
                    
                }


                
//                Assign server values for detail view
                
                SWAGRawValues.ServerValues.author = author
                SWAGRawValues.ServerValues.title = title

                if publisher != nil
                {
                SWAGRawValues.ServerValues.publisher = publisher!
                }
                SWAGRawValues.ServerValues.tags = tags
                SWAGRawValues.ServerValues.id = id

//                SWAGRawValues.ServerValues.author = ((response.responseObject as NSDictionary).valueForKey("author") as String)
//                SWAGRawValues.ServerValues.title = ((response.responseObject as NSDictionary).valueForKey("title") as String)
//                SWAGRawValues.ServerValues.lastCheckedOut = ((response.responseObject as NSDictionary).valueForKey("lastCheckedOut") as String)
//                SWAGRawValues.ServerValues.lastCheckedOutBy = ((response.responseObject as NSDictionary).valueForKey("lastCheckedOutBy") as String)
//                SWAGRawValues.ServerValues.bookCount = ((response.responseObject as NSDictionary).valueForKey("id") as String).toInt()!
                
//                checks for if book hasn't been checked out as of yet
                
                
                /*
                if SWAGRawValues.ServerValues.lastCheckedOut == nil
                {
                    SWAGRawValues.ServerValues.lastCheckedOut! = "This book has not been checked out as of yet."
                }
                
                if SWAGRawValues.ServerValues.lastCheckedOutBy == nil
                {
                    SWAGRawValues.ServerValues.lastCheckedOutBy = ""
                }
                
//                if book was checked out
                
                if SWAGRawValues.ServerValues.lastCheckedOut != nil
                {
                    SWAGRawValues.ServerValues.lastCheckedOut = lastCheckedOut
                }
                
                if SWAGRawValues.ServerValues.lastCheckedOutBy != nil
                {
                    SWAGRawValues.ServerValues.lastCheckedOutBy = lastCheckedOutBy
                }
                */
                
            }
            
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
            
                if error == true
                {
                    println("Oops, an error occurred \(error.localizedDescription)")
                }
                
        }
        
        
    }
    
    class func createNewBook() -> Bool
    {
        var isCreated = Bool()
        
        var bookValues: [String: String] = Dictionary()
        
        bookValues["author"] = SWAGRawValues.BookValues.author
        bookValues["title"] = SWAGRawValues.BookValues.title
        bookValues["publisher"] = SWAGRawValues.BookValues.publisher
        bookValues["categories"] = SWAGRawValues.BookValues.tags
        bookValues["lastCheckedOutBy"] = SWAGRawValues.BookValues.lastCheckedOutBy!
        bookValues["id"] = String(SWAGBookRetrieval.ArraysOf.bookID.last! + 1)
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        request.POST(Server.URL.rawValue, parameters: bookValues, success: { (response: HTTPResponse) -> Void in
            
         if response.responseObject != nil
         {
            isCreated = true
            println("Book succesfully created.")
            }
            
            
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
                
                isCreated = false
                println("An error occurred, the book could not be created. - \(error.localizedDescription)")
            
        }
        
        
        
        return isCreated
    }
    
    class func editABook(bookIndex: UInt) -> Bool
    {
        
        
        var hasBeenEdited = Bool()
        
//       first retrieve the specific book that you are looking for

        
        let bookNumber: UInt = bookIndex + 1
        let bookCharacter = String(bookNumber)
        
        
        let bookUrl: String = Server.URL.rawValue + bookCharacter
        
        //        use newly constructed url to search for the given book
        
        var bookValues: [String:String] = Dictionary()
        bookValues["lastCheckedOutBy"] = SWAGRawValues.BookValues.lastCheckedOutBy!
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        request.PUT(bookUrl, parameters: bookValues, success: { (response: HTTPResponse) -> Void in
            if response.responseObject != nil
            {
               println("The update was successful")
               hasBeenEdited = true
                
            }
            }) { (error: NSError, response: HTTPResponse?) -> Void in
            
               println("An error occurred updating the book - \(error.localizedDescription)")
                
                hasBeenEdited = false
        }
        
        return hasBeenEdited
        
    }
    
    class func deleteABook(bookIndex: UInt) -> Bool
    {
        var isDeleted = Bool()
        
//        find out correct book to search for
        let newIndex: UInt = ((SWAGBookRetrieval.ArraysOf.bookID as NSArray).objectAtIndex(Int(bookIndex)) as UInt)

        let bookUrl: String = Server.URL.rawValue + String(newIndex)
        
        
//     delete book that was selected
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        request.DELETE(bookUrl, parameters: nil, success: { (response: HTTPResponse) -> Void in
    //            let user know book has been deleted
            if response.responseObject != nil
            {
                println("Book has been deleted")
                
                isDeleted = true
            }
            
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
                
                SWAGRawValues.ServerValues.error = SWAGRawValues.Errors.DeletedBook.rawValue
               
                if error == true
                {
                     println("An error ocurred trying to delete the book - \(error.localizedDescription)")
                }
                
                
                isDeleted = false
                
        }
        
        return isDeleted
        
    }
    
    class func deleteAllBooks() -> Bool
    {
        var isDeleted = Bool()
        

//        delete all books
//        if return value is true, then tell user that all books are deleted
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        request.DELETE(Server.URL.rawValue, parameters: nil, success: { (response: HTTPResponse) -> Void in
            
            if response.responseObject != nil
            {
//              let user know all books has been deleted
                isDeleted = true
                
                
                
                
            }
            
            }) { (error: NSError, response: HTTPResponse?) -> Void in
            
                if error == true
                {
//                    let user know of error deleting all books
                    SWAGRawValues.ServerValues.error = SWAGRawValues.Errors.DeleteAllBooks.rawValue
                    isDeleted = false
                    
                }
        }
        
        
        return isDeleted
        
    }
    
}
