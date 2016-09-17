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
    
    func initialize(_ cat: String){
        self.titles = GameData().getGameList(cat)
        self.cat = cat
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white
        self.size = view.bounds.size
        print("Moved to scene ", titles)
        
        var count : CGFloat = self.size.height-35
        for title in titles {
            let label = SKLabelNode(text: title.title)
            label.position = CGPoint(x: CGFloat(self.size.width/2), y: count)
            label.fontColor = UIColor.black
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        print("touched: ", positionInScene.x, " ", positionInScene.y)
        
        let touchedNode = self.atPoint(positionInScene)
        if(touchedNode.name != nil){
            if(touchedNode.name == "title"){
                let cat : String = touchedNode.userData!.value(forKey: "category") as! String
                let subcat : String = touchedNode.userData!.value(forKey: "subcategory") as! String
                let words : String = touchedNode.userData!.value(forKey: "words") as! String
                let wordArr = words.components(separatedBy: ",")
            
                let scene = GameScene(fileNamed:"GameScene")
                scene!.initializeData(wordArr, category: cat, subcategory: subcat)
                let transition = SKTransition.moveIn(with: .right, duration: 0.5)
                view!.presentScene(scene!, transition: transition)
            }
        }
    }
}
