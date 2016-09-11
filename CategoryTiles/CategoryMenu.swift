//
//  CategoryMenu.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/10/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class CategoryMenu: SKScene{
    
    var titles = [TitleNode]()
    
    override func didMoveToView(view: SKView) {
        let data = GameData()
        self.size = view.bounds.size
        
        self.backgroundColor = UIColor.whiteColor()
        
        let categories : [TitleNode] = data.getCategoryList()
        titles = categories
        
        var count : CGFloat = self.size.height-35
        for title in categories {
            print("Label - ", title.title, count)
            let label = SKLabelNode(text: title.title)
            label.fontColor = UIColor.blackColor()
            label.position = CGPointMake(CGFloat(self.size.width/2), count)
            label.name = "title"
            count-=35
            title.setNode(label)
            self.addChild(label)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        if(touchedNode.name != nil){
            if(touchedNode.name=="title"){
                let label : SKLabelNode = touchedNode as! SKLabelNode
                let gameData : [TitleNode] = GameData().getGameList(label.text!)
                let scale = MenuScene(fileNamed: "MenuScene")
                scale?.initialize(gameData)
                self.view?.presentScene(scale)
            }
        }
    }
}