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
        
        
//        Assign values book values to be sent off to server
        
        SWAGRawValues.BookValues.title = bookTitleTF.text
        SWAGRawValues.BookValues.author = authorTF.text
        SWAGRawValues.BookValues.publisher = publisherTF.text
        SWAGRawValues.BookValues.tags = categoriesTF.text
        
        
        self.navigationController?.popViewControllerAnimated(true)
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
