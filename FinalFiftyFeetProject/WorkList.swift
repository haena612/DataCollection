//
//  WorkList.swift
//  FinalFiftyFeetProject
//
//  Created by Haena Kim on 10/15/16.
//  Copyright © 2016 Haena Kim. All rights reserved.
//


import UIKit
import CoreData

class WorkList {
    
    static let sharedInstance = WorkList()
    var work = [Work]()
//    var context: NSManagedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "Work")


    var currentlocationWorkList: Location?
    
    var counter = 0
//    lazy var context: NSManagedObjectContext = {
//        var managedObjectContext = NSManagedObjectContext(
//            concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = self.psc
//        return managedObjectContext
//    }()
    
    //----- coreDataStack start
    
    let modelName = "SurfJournalModel"
    let seedName = "SurfJournalDatabase"
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle()
            .URLForResource(self.modelName,
                            withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: self.managedObjectModel)
        let url =
            self.applicationDocumentsDirectory
                .URLByAppendingPathComponent(self.seedName + ".sqlite")
        
        // 1
        let bundle = NSBundle.mainBundle()
        let seededDatabaseURL = bundle
            .URLForResource(self.seedName, withExtension: "sqlite")!
        
        // 2
        let didCopyDatabase: Bool
        do {
            try NSFileManager.defaultManager()
                .copyItemAtURL(seededDatabaseURL, toURL: url)
            didCopyDatabase = true
        } catch {
            didCopyDatabase = false
        }
        
        // 3
        if didCopyDatabase {
            
            // 4
            let seededSHMURL = bundle
                .URLForResource(self.seedName, withExtension: "sqlite-shm")!
            let shmURL = self.applicationDocumentsDirectory
                .URLByAppendingPathComponent(self.seedName + ".sqlite-shm")
            do {
                try NSFileManager.defaultManager()
                    .copyItemAtURL(seededSHMURL, toURL: shmURL)
            } catch {
                let nserror = error as NSError
                print("Error: \(nserror.localizedDescription)")
                abort()
            }
            
            // 5
            let seededWALURL = bundle
                .URLForResource(self.seedName, withExtension: "sqlite-wal")!
            let walURL = self.applicationDocumentsDirectory
                .URLByAppendingPathComponent(self.seedName + ".sqlite-wal")
            do {
                try NSFileManager.defaultManager()
                    .copyItemAtURL(seededWALURL, toURL: walURL)
            } catch {
                let nserror = error as NSError
                print("Error: \(nserror.localizedDescription)")
                abort()
            }
            
            print("Seeded Core Data")
        }
        
        // 6
        do {
            try coordinator.addPersistentStoreWithType(
                NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            //7
            let nserror = error as NSError
            print("Error: \(nserror.localizedDescription)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(
            concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error: \(nserror.localizedDescription)")
                abort()
            }
        }
    }
    
    //----- coreDataStack end
    
    
    var count: Int {
        get{
            return work.count
        }
    }
    
    func workListIndex(index: Int) -> Work {
        return work[index]
    }
    
    func addWorkListwithName(name: String, date: String, cost: String, latLocation:String, longLocation:String) {
        
         let works = NSEntityDescription.insertNewObjectForEntityForName("Work", inManagedObjectContext: context) as! Work
        
        works.name = name
        works.date = date
        works.cost = cost
//        works.email = false
        works.longLocation = longLocation
        works.latLocation = latLocation
        work.append(works)
        
        saveContext()
    }
    

    
    
//    func removeWorkIndex(index: Int) {
//        context.deleteObject(workListIndex(index))
//        work.removeAtIndex(index)
//        saveContext()
//    }
    
//    func saveContext(){
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Error saving context: \(error), \(error.userInfo)")
//        }
//    }
    

    
    func fetchWork (){
        
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            work = results as! [Work]
            
            let sortDescriptor =
                NSSortDescriptor(key: "date", ascending: true)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
        } catch let error as NSError{
            print("Could not fetch works: \(error), \(error.userInfo)")
        }
    }
    
    
    private init(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
        fetchWork()
    }
}

