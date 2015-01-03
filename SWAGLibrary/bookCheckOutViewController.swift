//
//  bookCheckOutViewController.swift
//  SWAGLibrary
//
//  Created by Yose on 1/1/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

import UIKit

class bookCheckOutViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        println("\(nameTF.text)")
        SWAGRawValues.BookValues.lastCheckedOutBy = nameTF.text
        SWAGBookRetrieval.editABook(UInt(SWAGRawValues.BookValues.id))
        
//        Do edit for specific book with last checked out by
        
        self.dismissViewControllerAnimated(true, completion: nil)

        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
