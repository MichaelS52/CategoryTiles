//
//  DefaultDatabase.swift
//  CategoryTiles
//
//  Created by Bill Sylva on 9/8/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import UIKit
import CoreData

class DefaultDatabase: NSObject {
    let managedObjectContext = (UIApplication.shared.delegate
        as! AppDelegate).managedObjectContext
    
    override init() {
        
        super.init()
        
        
        //@NSManaged var title: String?
        //@NSManaged var complete: NSNumber?
        //@NSManaged var id: NSNumber?
        //@NSManaged var game: NSSet?
        
        print ("init default database")
        insertSports()
    }
    func insertTestCategories() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Category",
                                                                  in: managedObjectContext!)

        var testCat = Category(entity: entityDescription!,
                              insertInto: managedObjectContext)
        testCat.title = "Test1"
        testCat.complete = false
        testCat.id = 2
        
        testCat = Category(entity: entityDescription!,
                          insertInto: managedObjectContext)
        testCat.title = "Test2"
        testCat.complete = false
        testCat.id = 3
        
        testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test2"
        testCat.complete = false
        testCat.id = 3
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test3"
        testCat.complete = false
        testCat.id = 4
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test4"
        testCat.complete = false
        testCat.id = 5
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test5"
        testCat.complete = false
        testCat.id = 6
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test6"
        testCat.complete = false
        testCat.id = 7
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test7"
        testCat.complete = false
        testCat.id = 8
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test8"
        testCat.complete = false
        testCat.id = 9
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test9"
        testCat.complete = false
        testCat.id = 10
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test10"
        testCat.complete = false
        testCat.id = 11
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test11"
        testCat.complete = false
        testCat.id = 12
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test12"
        testCat.complete = false
        testCat.id = 13
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test13"
        testCat.complete = false
        testCat.id = 14
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test14"
        testCat.complete = false
        testCat.id = 15
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test15"
        testCat.complete = false
        testCat.id = 16
                testCat = Category(entity: entityDescription!,
                           insertInto: managedObjectContext)
        testCat.title = "Test16"
        testCat.complete = false
        testCat.id = 17
        
        
        
    }
    
    func insertSports() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Category",
                                                                  in: managedObjectContext!)
        
        let newCat = Category(entity: entityDescription!,
                                 insertInto: managedObjectContext)
        newCat.title = "Sports"
        newCat.complete = false
        newCat.id = 1

        let gameRelation = newCat.value(forKeyPath: "game")
        var game = insertGame("Hockey", a1: "puck", a2: "goalie", a3: "stick", a4: "penalty", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Basketball", a1: "rim", a2: "rebound", a3: "zone", a4: "gaurd", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        
        game = insertGame("Football", a1: "snap", a2: "tackle", a3: "punt",
                           a4:"block", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Baseball", a1: "pitcher", a2: "homerun", a3: "outfield",
                           a4:"strike", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Soccer", a1: "freekick", a2: "header", a3: "offside",
                           a4:"corner", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Golf", a1: "par", a2: "bogey", a3: "fairway",
                           a4:"bunker", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Bowling", a1: "gutter", a2: "alley", a3: "spare",
                           a4:"split", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Auto Racing", a1: "pitstop", a2: "draft", a3: "fuel",
                           a4:"speed", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Lacrosse", a1: "box", a2: "head", a3: "check",
                           a4:"pick", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Tennis", a1: "deuce", a2: "ace", a3: "serve",
                           a4:"let", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Cricket", a1: "bowling", a2: "googly", a3: "over",
                           a4:"wicket", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        game = insertGame("Volleyball", a1: "bump", a2: "setter", a3: "kill",
                           a4:"serve", cat: newCat)
        (gameRelation! as AnyObject).add(game)
        
        insertTestCategories()
    }

    func insertGame (_ title:String, a1:String, a2:String, a3: String, a4:String, cat:Category) -> Game {
        //var manyRelation = myObject.valueForKeyPath("subObjects") as NSMutableSet
        //manyRelation.addObject(subObject)
        let entityDescription = NSEntityDescription.entity(forEntityName: "Game",
                                                                  in: managedObjectContext!)
        
        let newGame = Game(entity: entityDescription!,
                              insertInto: managedObjectContext)
        newGame.title = title
        newGame.complete = false
        newGame.category = cat
        
        let solRelation = newGame.value(forKeyPath: "solution")
        var sol = insertSolution(a1, id: 1, game:newGame)
        (solRelation! as AnyObject).add(sol)
        sol = insertSolution(a2, id: 2, game:newGame)
        (solRelation! as AnyObject).add(sol)
        sol = insertSolution(a3, id: 3, game:newGame)
        (solRelation! as AnyObject).add(sol)
        sol = insertSolution(a4, id: 4, game:newGame)
        (solRelation! as AnyObject).add(sol)

        return newGame
    }
    func insertSolution (_ answer: String, id: Int, game: Game) -> Solution {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Solution",
                                                                  in:managedObjectContext!)
        let newSolution = Solution(entity: entityDescription!, insertInto: managedObjectContext)
        newSolution.answer = answer
        newSolution.answerId = id as NSNumber?
        newSolution.complete = false
        newSolution.game = game

        return newSolution
    }
}
