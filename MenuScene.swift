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
    
    func initialize(titles: [TitleNode]){
        self.titles = titles
    }
    
    override func didMoveToView(view: SKView) {
        
        let data = GameData()
        data.dumpDatabase()
        self.backgroundColor = UIColor.whiteColor()
        
        print("Moved to scene ", titles)
        
        var count = self.size.height-35
        for title in titles {
            let label = SKLabelNode(text: title.title)
            label.position = CGPointMake(CGFloat(self.size.width/2), count)
            count-=35
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.locationInNode(self)
        print("touched: ", positionInScene.x, " ", positionInScene.y)
        
        let touchedNode = self.nodeAtPoint(positionInScene)
        if(touchedNode.userData?.valueForKey("destination") != nil){
            var cat : String = touchedNode.userData!.valueForKey("category") as! String
            var subcat : String = touchedNode.userData!.valueForKey("subcategory") as! String
            var words : String = touchedNode.userData!.valueForKey("words") as! String
            var wordArr = words.componentsSeparatedByString(",")
            
            if let scene = GameScene(fileNamed:"GameScene") {
                // Configure the view.
                let skView = self.view! as! SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
            
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
            
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
            
                //modify scene properties
                scene.initializeData(wordArr, category: cat, subcategory: subcat)
                
                let transition = SKTransition.moveInWithDirection(.Right, duration: 0.5)
                skView.presentScene(scene, transition: transition)
            }
        }
    }
}
