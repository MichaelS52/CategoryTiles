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
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        self.size = view.bounds.size
        let start = SKLabelNode(text: "Sports / Hockey");
        start.fontColor = UIColor.blackColor()
        start.position = CGPointMake(view.bounds.width/2, view.bounds.height/2)
        start.userData = [
            "category" : "Sports",
            "subcategory" : "Hockey",
            "words" : "stick,puck,goalie,penalty",
            "destination" : "gameboard"
        ]
        self.addChild(start)
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
