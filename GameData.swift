//
//  GameData.swift
//  CategoryTiles
//
//  Created by Bill Sylva on 9/7/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameData: NSObject {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    override init() {
        
        super.init()
        print ("init database")
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Category")
        do {
            let result = try managedObjectContext!.executeFetchRequest(fReq)
            
            print(result.count)
            
            if (result.count == 0)
            {
                print ("result = 0")
                // initalizeWorkoutDB()
            }
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
    }
    
    func getMOC() -> NSManagedObjectContext {
        return managedObjectContext!
    }
    
    func initalizeGameDB() {
        print ("save new database")
        // Save all the new data
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            // failure
            print("save failed: \(error.localizedDescription)")
        }
    }
    
}
    