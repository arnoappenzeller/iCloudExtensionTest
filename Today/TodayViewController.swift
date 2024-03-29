//
//  TodayViewController.swift
//  Today
//
//  Created by Arno Appenzeller on 12.09.14.
//  Copyright (c) 2014 Arno. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var managedObjectContext: NSManagedObjectContext?
        
    @IBOutlet weak var extLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedObjectContext = CoreDataStack(docURL: self.applicationDocumentsDirectory,modelURL: self.mmodelUrl).managedObjectContext!
        let object = self.fetchedResultsController.fetchedObjects!.first  as NSManagedObject
        self.extLabel!.text = object.valueForKey("timeStamp")!.description
        

        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let storeUrl = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.APPenzeller.StechkarteNCExt")
        return storeUrl!.URLByAppendingPathComponent("iCloudExtensionTest.sqlite")
        }()
    
    lazy var mmodelUrl: NSURL = {
        let modelUrl = NSBundle.mainBundle().URLForResource("iCloudExtensionTest", withExtension: "momd")!
        return modelUrl
    }()
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
            }
            
            let fetchRequest = NSFetchRequest()
            // Edit the entity name as appropriate.
            let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
            fetchRequest.entity = entity
            
            // Set the batch size to a suitable number.
            fetchRequest.fetchBatchSize = 20
            
            // Edit the sort key as appropriate.
            let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
            let sortDescriptors = [sortDescriptor]
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
            //aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController
            
            var error: NSError? = nil
            if !_fetchedResultsController!.performFetch(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            
            return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
}
