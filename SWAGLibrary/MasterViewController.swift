//
//  MasterViewController.swift
//  SWAGLibrary
//
//  Created by Yose on 12/22/14.
//  Copyright (c) 2014 Yose. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


    override func awakeFromNib() {
        super.awakeFromNib()

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        SWAGBookRetrieval.authorForBooks()
        
        GCDDispatch.after(2.0, closure: { () -> () in
        println("The book count is \(SWAGBookRetrieval.ArraysOf.authors.count)")
        
            self.tableView.reloadData()
        })
    
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "toAddBookSegue:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            

            if let indexPath = self.tableView.indexPathForSelectedRow() {
                println("The selected index row \(indexPath.row)")
                SWAGBookRetrieval.retrieveASpecificBook(UInt(indexPath.row))
                SWAGRawValues.BookValues.id = Int(indexPath.row)
                
//                let object = objects[indexPath.row] as NSDate
//                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    func toAddBookSegue(sender: AnyObject)
    {
        self.performSegueWithIdentifier("addBook", sender: sender)
        
        
    }
    
    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SWAGBookRetrieval.ArraysOf.authors.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel!.text = SWAGBookRetrieval.ArraysOf.title[indexPath.row]
        cell.detailTextLabel!.text = SWAGBookRetrieval.ArraysOf.authors[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {


//            this is where single books will be deleted from
            
            
            SWAGBookRetrieval.deleteABook(UInt(indexPath.row))
            SWAGBookRetrieval.ArraysOf.authors.removeAtIndex(indexPath.row)
//            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}



