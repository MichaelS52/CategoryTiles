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
        let gesture = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        view.addGestureRecognizer(gesture)
        
        let categories : [TitleNode] = data.getCategoryList()
        titles = categories
        
        var count : CGFloat = self.size.height-50
        for title in categories {
            var spriteNode : SKSpriteNode? = nil
            if(title.title=="Sports"){
                spriteNode = SKSpriteNode(imageNamed: "sportsbanner.png")
            }else{
                spriteNode = SKSpriteNode(imageNamed: "blankbanner.png")
            }
            
            spriteNode!.position = CGPointMake(CGFloat(self.size.width/2), count)
            spriteNode!.name = title.title
            count-=90
            title.setNode(spriteNode!)
            self.addChild(spriteNode!)
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer){
        let touch = recognizer.locationOfTouch(0, inView: view)
        let touchedNode = self.nodeAtPoint(touch)
        if(touchedNode.name != nil){
            let scene = MenuScene(fileNamed: "MenuScene")
            scene?.initialize(touchedNode.name!)
            self.view?.presentScene(scene)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}