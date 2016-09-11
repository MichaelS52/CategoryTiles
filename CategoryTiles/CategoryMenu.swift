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
        let data = GameData()
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        if(touchedNode.name != nil){
            if(touchedNode.name=="title"){
                for title in titles{
                    if((title.getNode()?.isEqualToNode(touchedNode)) != nil){
                        let scene = MenuScene(fileNamed: "MenuScene")
                        let skView = self.view!
                        let subMenu = data.getGameList(title.title)
                        print("submenu ",subMenu)
                        scene!.initialize(subMenu)
                        skView.presentScene(scene)
                        return
                    }
                }
            }
        }
    }
}