//
//  DetailViewController.swift
//  SWAGLibrary
//
//  Created by Yose on 12/22/14.
//  Copyright (c) 2014 Yose. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

//    View outlets
    
    @IBOutlet weak var bookTitle: UITextView!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var publisher: UILabel!
    
    @IBOutlet weak var tags: UILabel!
    
    @IBOutlet weak var checkedOutTF: UITextView!

    @IBOutlet weak var staticPublisher: UILabel!
    
    @IBOutlet weak var staticTags: UILabel!
    
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

  
    
    func fadeIn()
    {
     
        func zeroAlpha()
        {
            bookTitle.alpha = 0
            author.alpha = 0
            publisher.alpha = 0
            tags.alpha = 0
            checkedOutTF.alpha = 0
            staticPublisher.alpha = 0
            staticTags.alpha = 0
        }
        
        zeroAlpha()
        
        UIView.animateWithDuration(2.5, animations: { () -> Void in
            self.bookTitle.alpha = 1
            self.author.alpha = 1
            self.publisher.alpha = 1
            self.tags.alpha = 1
            self.checkedOutTF.alpha = 1
            self.staticPublisher.alpha = 1
            self.staticTags.alpha = 1
        })
   
     
    }
    
    
    @IBAction func shareTo(sender: UIBarButtonItem) {
        
//        bring up a form sheet to allow user to select 
//        either Twitter or Facebook to share to
        
        let actionSheet = UIActionSheet(title: "Where would you like to share this book information to?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Facebook", "Twitter")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(self.view)
        
        // MARK: UIActionSheetDelegate
      
        
        
    }
    
    
    
//    delay animate the view due to having to retrieve values from server
    
    func listValues()
    {
        println("The author is \(SWAGRawValues.ServerValues.author) and the book title is \(SWAGRawValues.ServerValues.title) with publisher \(SWAGRawValues.ServerValues.publisher)")
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
                
//                Assign server values to respective textfields / labels
//                println("The title is \(SWAGRawValues.ServerValues.bookCount)")
                
                
               
                
            }
        }
        
        GCDDispatch.after(0.15, closure: { () -> () in
            self.author.text = SWAGRawValues.ServerValues.author
            self.bookTitle.text = SWAGRawValues.ServerValues.title
            self.tags.text = SWAGRawValues.ServerValues.tags
            self.publisher.text = SWAGRawValues.ServerValues.publisher
            self.checkedOutTF.text = "Last Checked Out: \(SWAGRawValues.ServerValues.lastCheckedOut!) \(SWAGRawValues.ServerValues.lastCheckedOutBy!) "

            
            
        
            


        })
    }

    
    
    override func viewWillAppear(animated: Bool) {
        fadeIn()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.listValues()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

