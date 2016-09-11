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
import SpriteKit

class TitleNode {
    var title:String = ""
    var complete:Bool = false
    var sprite:SKNode?
    
    init(t:String, done: Bool){
        self.title = t
        self.complete = done
        self.sprite = nil
    }
    
    func setNode(sprite: SKNode){
        self.sprite = sprite
    }
    func getNode() -> SKNode?{
        return self.sprite
    }
    
    func debugPrint(){
        print("Title - ",self.title)
        print("complete - ",self.complete)
    }
}


class GameData: NSObject {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    override init() {
        
        super.init()
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Category")
        do {
            let result = try managedObjectContext!.executeFetchRequest(fReq)
            
            print(result.count)
            
            if (result.count == 0)
            {
                print ("result = 0")
                initalizeGameDB()
            } else {
                print ("database exists")
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
        _ = DefaultDatabase();
        print ("save new database")
        // Save all the new data
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            // failure
            print("save failed: \(error.localizedDescription)")
        }
    }
    
    func getCategoryList() -> [TitleNode] {
        let fetchReq = NSFetchRequest(entityName: "Category")
        var titles:[TitleNode] = []
        
        do {
            let result = try managedObjectContext!.executeFetchRequest(fetchReq)
            for resultItem in result  {
                let catItem = resultItem as! Category
                var done = false
                if (catItem.complete == true) {
                    done = true
                }
                let newTitle = TitleNode(t: catItem.title!, done: done)
                titles.append(newTitle)
            }
        
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return titles
    }
    
    func getGameList(category:String) -> [TitleNode] {
        let fetchReq = NSFetchRequest(entityName: "Game")
        fetchReq.predicate = NSPredicate(format: "category.title = %@", category)
        var titles:[TitleNode] = []
        
        do {
            let result = try managedObjectContext!.executeFetchRequest(fetchReq)
            for resultItem in result  {
                let catItem = resultItem as! Game
                var done = false
                if (catItem.complete == true) {
                    done = true
                }
                let newTitle = TitleNode(t: catItem.title!, done: done)
                titles.append(newTitle)
            }
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return titles
    }
    
    func getPuzzle(category:String, game: String) -> String {
        print ("getPuzzle \(category) \(game)")
        let fetchReq = NSFetchRequest(entityName: "Solution")
        fetchReq.predicate = NSPredicate(format: "game.title = %@ AND game.category.title = %@",
                                         game, category)
        // var titles:[TitleNode] = []
        var retString = ""
        var count = 0

        do {
            let result = try managedObjectContext!.executeFetchRequest(fetchReq)
            for resultItem in result  {
                let solItem = resultItem as! Solution
                var done = false
                if (solItem.complete == true) {
                    done = true
                }
                if (count > 0) {
                    retString = retString + ","
                }
                print ("==>\(solItem.answer)")
                retString = retString + solItem.answer!
                count += 1
                
                //let newTitle = TitleNode(t: catItem.title!, done: done)
                // titles.append(newTitle)
            }
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return retString
    }

    func dumpDatabase() {
        var fetchReq = NSFetchRequest(entityName: "Category")
        //fetchReq.predicate = NSPredicate(format:"ANY")
        do {
            let result = try managedObjectContext!.executeFetchRequest(fetchReq)
            for resultItem in result  {
                let catItem = resultItem as! Category
                print ("category = \(catItem.title)")
                fetchReq = NSFetchRequest(entityName: "Game")
                fetchReq.predicate = NSPredicate(format: "category.title = %@", catItem.title!)
                do {
                    let result2 = try managedObjectContext!.executeFetchRequest(fetchReq)
                    for resultItem2 in result2  {
                        let gameItem = resultItem2 as! Game
                        print ("game = \(gameItem.title)")
                    }
                }
                catch let error2 as NSError {
                    // failure
                    print("Fetch failed: \(error2.localizedDescription)")
                    }
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

    func dumpDatabaseShort() {
        //
        print ("----------------------------------")
        print ("get with get functions")
        let catList = getCategoryList()
        for cat in catList {
            print("\(cat.title) - \(cat.complete)")
            let gameList = getGameList(cat.title)
            for game in gameList {
                print ("--\(game.title) - \(game.complete)")
                let aList = getPuzzle(cat.title, game: game.title)
                print ("----\(aList)")
            }
        }
        
        print ("----------------------------------")
    }
    
}
    