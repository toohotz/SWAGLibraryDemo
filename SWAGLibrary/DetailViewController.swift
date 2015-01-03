//
//  DetailViewController.swift
//  SWAGLibrary
//
//  Created by Yose on 12/22/14.
//  Copyright (c) 2014 Yose. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

//    View outlets
    
    @IBOutlet weak var bookTitle: UITextView!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var publisher: UILabel!
    
    @IBOutlet weak var tags: UILabel!
    
    @IBOutlet weak var checkedOutTF: UITextView!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

//    delay animate the view due to having to retrieve values from server
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
                
//                Assign server values to respective textfields / labels
//                println("The title is \(SWAGRawValues.ServerValues.bookCount)")
                
                
               
                
            }
        }
        
        GCDDispatch.after(1.5, closure: { () -> () in
            self.author.text = SWAGRawValues.ServerValues.author
            self.bookTitle.text = SWAGRawValues.ServerValues.title
            self.tags.text = SWAGRawValues.ServerValues.tags
            self.publisher.text = SWAGRawValues.ServerValues.publisher
            self.checkedOutTF.text = "Last Checked Out: \(SWAGRawValues.ServerValues.lastCheckedOut!) \(SWAGRawValues.ServerValues.lastCheckedOutBy!) "

            
            
        
            


        })
    }

    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

