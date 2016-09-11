//
//  MenuScene.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/6/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var titles = [TitleNode]()
    var cat : String = ""
    
    func initialize(cat: String){
        self.titles = GameData().getGameList(cat)
        self.cat = cat
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.whiteColor()
        self.size = view.bounds.size
        print("Moved to scene ", titles)
        
        var count : CGFloat = self.size.height-35
        for title in titles {
            let label = SKLabelNode(text: title.title)
            label.position = CGPointMake(CGFloat(self.size.width/2), count)
            label.fontColor = UIColor.blackColor()
            label.name = "title"
            let words = GameData().getPuzzle(cat,game: title.title)
            print("Words:",words)
            
            label.userData = [
                "category":cat,
                "subcategory":title.title,
                "words":GameData().getPuzzle(cat, game: title.title)
            ]
            count-=35
            self.addChild(label)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.locationInNode(self)
        print("touched: ", positionInScene.x, " ", positionInScene.y)
        
        let touchedNode = self.nodeAtPoint(positionInScene)
        if(touchedNode.name != nil){
            if(touchedNode.name == "title"){
                let cat : String = touchedNode.userData!.valueForKey("category") as! String
                let subcat : String = touchedNode.userData!.valueForKey("subcategory") as! String
                let words : String = touchedNode.userData!.valueForKey("words") as! String
                let wordArr = words.componentsSeparatedByString(",")
            
                let scene = GameScene(fileNamed:"GameScene")
                scene!.initializeData(wordArr, category: cat, subcategory: subcat)
                let transition = SKTransition.moveInWithDirection(.Right, duration: 0.5)
                view!.presentScene(scene!, transition: transition)
            }
        }
    }
}
