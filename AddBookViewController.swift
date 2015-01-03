//
//  AddBookViewController.swift
//  SWAGLibrary
//
//  Created by Yose on 12/24/14.
//  Copyright (c) 2014 Yose. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    
//    UI outlets
    
    @IBOutlet weak var bookTitleTF: UITextField!
    
    @IBOutlet weak var authorTF: UITextField!
    
    @IBOutlet weak var publisherTF: UITextField!
    
    @IBOutlet weak var categoriesTF: UITextField!
    

    
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        println("The number of books are \(SWAGRawValues.ServerValues.bookCount)")

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    function that converts the current time into the time format that the server requires
    
//    yyyy-MM-dd HH:mm:ss zzz
    
    func currentTimeServerFormatting() -> String
    {
        var outputDate = String()
        
        let currentDate = NSDate()
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        
        outputDate = dateFormatter.stringFromDate(currentDate)
        
        return outputDate
    }
    
    
    
    @IBAction func closeVC(sender: AnyObject) {
        
//        checks first to see if any text fields have text within them before
//        leaving screen
        

        func checkIfFieldsAreLeftEmpty() -> Bool
        {
            var isOkay = true
            
            let bookLength = countElements(bookTitleTF!.text)
            let authorLength = countElements(authorTF!.text)
            let publisherLength = countElements(publisherTF.text)
            let tagsLength = countElements(categoriesTF.text)
            
             if bookLength <= 2 || authorLength <= 2 || publisherLength <= 2 || tagsLength <= 2
             {
                isOkay = false
                
            }
            
           
            
            return isOkay
        }
        
        
//        Assign values book values to be sent off to server
        
        func assignServerValues()
        {
            SWAGRawValues.BookValues.title = bookTitleTF.text
            SWAGRawValues.BookValues.author = authorTF.text
            SWAGRawValues.BookValues.publisher = publisherTF.text
            SWAGRawValues.BookValues.tags = categoriesTF.text
            SWAGRawValues.BookValues.lastCheckedOut! = currentTimeServerFormatting()
            SWAGRawValues.BookValues.lastCheckedOutBy! = "Not checked out yet"
        }
        
        if checkIfFieldsAreLeftEmpty() == false
        {
            let alert = UIAlertController(title: "Oops!", message: "It appears that you have left a field blank when trying to make a new book. Are you sure you would like to close this screen?", preferredStyle: UIAlertControllerStyle.Alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {action in
                
             switch action.style
             {
             case .Default:
                println("User said to leave ")
                self.navigationController?.popViewControllerAnimated(true)
                
             default:
                println("")
                
                
                }
                
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "I'll Stay", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                
                switch action.style
                {
                case .Default:
                println("User said to stay")
                
                case .Cancel:
                println("Do nothing user wants to stay on screen")
                
                case .Destructive:
                println("User confirmed wanted to leave")
            }
                
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
//        if no fields are left empty then just dismiss view
        
        if checkIfFieldsAreLeftEmpty() == true
        {
            self.navigationController?.popViewControllerAnimated(true)
        }

//        take values and send off to server to create a new book
        assignServerValues()
        
        if SWAGBookRetrieval.createNewBook() == true
        {
            println("The function returned to be true")
        }
        
        if SWAGBookRetrieval.createNewBook() == false
        {
            println("The function returned to be false")
        }
        
    }
    
//    Our object that will be in place of thee response received
  

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
