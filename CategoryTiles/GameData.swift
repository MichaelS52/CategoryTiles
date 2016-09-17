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
    
    func setNode(_ sprite: SKNode){
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
    
    let managedObjectContext = (UIApplication.shared.delegate
        as! AppDelegate).managedObjectContext
    
    override init() {
        
        super.init()
        let fReq: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        do {
            
            let result = try managedObjectContext!.fetch(fReq)
            
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
        var titles:[TitleNode] = []
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        do {
            let result = try managedObjectContext!.fetch(fetchReq)
            for resultItem in result  {
                let catItem = resultItem
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
    
    func getGameList(_ category:String) -> [TitleNode] {
        let fetchReq: NSFetchRequest<Game> = Game.fetchRequest() as! NSFetchRequest<Game>
        fetchReq.predicate = NSPredicate(format: "category.title = %@", category)
        var titles:[TitleNode] = []
        
        do {
            let result = try managedObjectContext!.fetch(fetchReq)
            for resultItem in result  {
                let catItem = resultItem 
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
    
    func getPuzzle(_ category:String, game: String) -> String {
        print ("getPuzzle \(category) \(game)")
        let fetchReq: NSFetchRequest<Solution> = Solution.fetchRequest() as! NSFetchRequest<Solution>
        fetchReq.predicate = NSPredicate(format: "game.title = %@ AND game.category.title = %@",
                                         game, category)
        // var titles:[TitleNode] = []
        var retString = ""
        var count = 0

        do {
            let result = try managedObjectContext!.fetch(fetchReq)
            for resultItem in result  {
                let solItem = resultItem
                var done = false
                if (solItem.complete == true) {
                    done = true
                }
                if (count > 0) {
                    retString = retString + ","
                }
                print ("==>\(solItem.answer) - \(done)")
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
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest() as! NSFetchRequest<Category>
        //fetchReq.predicate = NSPredicate(format:"ANY")
        do {
            let result = try managedObjectContext!.fetch(fetchReq)
            for resultItem in result  {
                let catItem = resultItem
                print ("category = \(catItem.title)")
                let fetchReqGame: NSFetchRequest<Game> = Game.fetchRequest() as! NSFetchRequest<Game>
                fetchReqGame.predicate = NSPredicate(format: "category.title = %@", catItem.title!)
                do {
                    let result2 = try managedObjectContext!.fetch(fetchReqGame)
                    for resultItem2 in result2  {
                        let gameItem = resultItem2 
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
    
