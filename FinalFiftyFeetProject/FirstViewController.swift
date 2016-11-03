//
//  FirstViewController.swift
//  FinalFiftyFeetProject
//
//  Created by Haena Kim on 10/15/16.
//  Copyright © 2016 Haena Kim. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class FirstViewController: UIViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate, SecondViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultController: NSFetchedResultsController = self.surfJournalfetchedResultController()
    
    override func viewWillAppear(animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
        tableView.reloadData()
        // Do any additional setup after loading the view.

    }
    
     // MARK: - NSFetchedResultsController
    func surfJournalfetchedResultController()
        -> NSFetchedResultsController {
            
            
            let fetchRequest = WorkList.sharedInstance.fetchRequest
            fetchedResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: WorkList.sharedInstance.context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            fetchedResultController.delegate = self
            
            
            do {
                try fetchedResultController.performFetch()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
            
            return fetchedResultController
    }
    
    func surfJournalFetchRequest() -> NSFetchRequest {
        
        let fetchRequest =
            NSFetchRequest(entityName: "Work")
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor =
            NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller:
        NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
//    func numberOfSectionsInTableView(
//        tableView: UITableView) -> Int {
//            return fetchedResultController.sections!.count
//    }
//    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return WorkList.sharedInstance.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath:indexPath) as! AddCell
        
        let worklist = WorkList.sharedInstance.workListIndex(indexPath.row)
        
        var longValue = ""
        var latValue = ""
        
        if worklist.longLocation != nil{
            longValue = worklist.longLocation!
        }
        if worklist.latLocation != nil{
            latValue = worklist.latLocation!
        }
        cell.nameLabel.text = worklist.name
        cell.dateLabel.text = worklist.date
        
        cell.costLabel.text = worklist.cost
        //    setCheckmarkForCell(cell, completed: worklist.completed)
        return cell
    }
    
    func configureCell(cell: AddCell, indexPath: NSIndexPath){
        let worklist = fetchedResultController.objectAtIndexPath(indexPath) as! Work
        
//        if worklist.longLocation != nil{
//            var longValue = worklist.longLocation!
//        }
//        if worklist.latLocation != nil{
//            var latValue = worklist.latLocation!
//        }
        cell.nameLabel.text = worklist.name
        cell.dateLabel.text = worklist.date
        
        cell.costLabel.text = worklist.cost
    }

//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let workEntry = fetchedResultController.objectAtIndexPath(indexPath) as! Work
            WorkList.sharedInstance.context.deleteObject(workEntry)
            WorkList.sharedInstance.saveContext()
            
            //            WorkList.sharedInstance.removeWorkIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 200;
    }
    
    
    // MARK: - Segues

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //1
        if segue.identifier == "SegueListToDetail"{
            
            //2
            let indexPath = tableView.indexPathForSelectedRow
//            let indexPathrow = tableView.indexPathForSelectedRow!.row
            let workEntry = fetchedResultController.objectAtIndexPath(indexPath!) as! Work
            
            //3
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = navigationController.topViewController as! SecondViewController
            
            //4
            detailViewController.workEntry = workEntry
            detailViewController.context = workEntry.managedObjectContext!
            detailViewController.delegate = self
            
            WorkList.sharedInstance.counter = 1
        }
        if segue.identifier == "SegueListToDetailAdd"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = navigationController.topViewController as! SecondViewController
            
            let workEntryEntity = NSEntityDescription.entityForName("Work",inManagedObjectContext: WorkList.sharedInstance.context)
            let newworkEntry = Work(entity: workEntryEntity!,insertIntoManagedObjectContext:WorkList.sharedInstance.context)
            
            detailViewController.workEntry = newworkEntry
            detailViewController.context = newworkEntry.managedObjectContext!
            detailViewController.delegate = self
        
            WorkList.sharedInstance.counter = 2
        }
    }
    
    // Export csv
    
    @IBAction func exportButtonTapped(sender: UIBarButtonItem!) {
        exportCSVFile()
    }
    
        func activityIndicatorBarButtonItem() -> UIBarButtonItem {
            let activityIndicator =
                UIActivityIndicatorView(activityIndicatorStyle:
                    UIActivityIndicatorViewStyle.Gray)
            let barButtonItem =
                UIBarButtonItem(customView: activityIndicator)
            activityIndicator.startAnimating()
    
            return barButtonItem
        }
    
        func exportBarButtonItem() -> UIBarButtonItem {
    
            return UIBarButtonItem(
                title: "Export", style: UIBarButtonItemStyle.Plain,
                target: self, action: #selector(FirstViewController.exportButtonTapped(_:)))
        }
    
    func showExportFinishedAlertView(exportPath: String) {
        
        let message =
            "The exported CSV file can be found at \(exportPath)"
        let alertController = UIAlertController(title: "Export Finished",
                                                message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default,
                                     handler: nil)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true,
                              completion: nil)
    }
    
    
    func exportCSVFile() {
        
        //        navigationItem.leftBarButtonItem = activityIndicatorBarButtonItem()
        
        // 1
        let results: [AnyObject]
        do {
            
            results = try WorkList.sharedInstance.context.executeFetchRequest(
                WorkList.sharedInstance.fetchRequest)
            
            for result in results{
                if result.valueForKey("name") != nil{
                    print("name")
                }
            }
        } catch {
            let nserror = error as NSError
            print("ERROR: \(nserror)")
            results = []
        }
        
        // 2
        let exportFilePath =
            NSTemporaryDirectory() + "export.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        NSFileManager.defaultManager().createFileAtPath(
            exportFilePath, contents: NSData(), attributes: nil)
        
        // 3
        let fileHandle: NSFileHandle?
        do {
            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
        } catch {
            let nserror = error as NSError
            print("ERROR: \(nserror)")
            fileHandle = nil
        }
        
        if let fileHandle = fileHandle {
            // 4
            for object in results {
                let work2 = object as! Work
                
                fileHandle.seekToEndOfFile()
                let csvData = work2.csv().dataUsingEncoding(
                    NSUTF8StringEncoding, allowLossyConversion: false)
                fileHandle.writeData(csvData!)
            }
            
            // 5
            fileHandle.closeFile()
            
            print("Export Path: \(exportFilePath)")
            //            self.navigationItem.leftBarButtonItem =
            //                self.exportBarButtonItem()
            self.showExportFinishedAlertView(exportFilePath)
        } else {
            //            self.navigationItem.leftBarButtonItem =
            //                self.exportBarButtonItem()
        }
        
    }
    
    // MARK: - SecondViewControllerDelegate
    
    func didFinishViewController(
        viewController:SecondViewController, didSave:Bool) {
        
        // 1
        if didSave {
            // 2
            let context = viewController.context
            context.performBlock({ () -> Void in
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        print("Error: \(nserror.localizedDescription)")
                        abort()
                    }
                }
                
                // 3
                WorkList.sharedInstance.saveContext()
            })
        }
        
        // 4
        dismissViewControllerAnimated(true, completion: {})
    }

    
    //checkmark
//    func setCheckmarkForCell(cell: UITableViewCell, completed: Bool){
//        if completed {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//        }
//    }

    
    //    //email
    //    func configureMainComposeViewController() -> MFMailComposeViewController{
    //        let emailController = MFMailComposeViewController()
    //        emailController.mailComposeDelegate = self
    //        //        emailController.setSubject("CSV File")
    //        //        emailController.setMessageBody("", isHTML: false)
    //
    //        emailController.setToRecipients(["haena612@gmail.com"])
    //        emailController.setSubject("This is a text email")
    //        emailController.setMessageBody("HI", isHTML: false)
    //
    //
    //        //        emailController.addAttachmentData(data!, mimeType: <#T##String#>, fileName: <#T##String#>)
    //        return emailController
    //
    //    }
    //
    //    func showSendMailErrorAlert(){
    //        let sendMailErrorAlert = UIAlertView(title: "Could not send email", message: "Your device can't send the email. Please check your email configuration and try again", delegate: self, cancelButtonTitle: "OK")
    //        sendMailErrorAlert.show()
    //    }
    //
    //    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    //
    //        switch result.rawValue{
    //
    //        case MFMailComposeResultCancelled.rawValue:
    //            print("cancelled mail")
    //
    //        case MFMailComposeResultSent.rawValue:
    //            print("mail sent")
    //
    //        default:
    //            break
    //        }
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    // tableView delegate methods
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if self.tableView.indexPathForSelectedRow!.row == indexPath.row{
//            print("match")
//        }
    
//
//        let worklist = WorkList.sharedInstance.workListIndex(indexPath.row)
//        let cell = tableView.cellForRowAtIndexPath(indexPath)!
//        
//        worklist.completed = !worklist.completed
//        WorkList.sharedInstance.saveContext()
//        setCheckmarkForCell(cell, completed: worklist.completed)
//        
//        
//        //emailFUNCTION
//        //        let mailComposeViewController = configureMainComposeViewController()
//        //
//        //        if MFMailComposeViewController.canSendMail(){
//        //            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//        //        } else{
//        //            self.showSendMailErrorAlert()
//        //        }
//        //        }
//        
}