//
//  GameScene.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/3/16.
//  Copyright (c) 2016 Michael Sylva. All rights reserved.
//

import SpriteKit
import CoreMotion

var cat = "Sports"
var subcat = "Hockey"

var tiles = [Tile]()
var motionManager = CMMotionManager()

class Tile{
    var sprite : SKSpriteNode
    
    init(sprite: SKSpriteNode){
        self.sprite = sprite
    }
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.size = view.bounds.size //set the size to the view size
        
        /* Create a few test tiles */
        for var i = 1; i<=200; i+=30{
            for var j = 1; j<=100; j+=30{
                let t : Tile = createTile("x");
                t.sprite.position = CGPointMake(CGFloat(i), CGFloat(j))
            }
        }
        
        /* startup function */
        setupScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch is began */
        let touch = touches.first!
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        for t in tiles{
            if(touchedNode.isEqualToNode(t.sprite)){
                print("touched.")
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if let accData = motionManager.accelerometerData{
            physicsWorld.gravity = CGVector(dx: accData.acceleration.x * 2, dy: accData.acceleration.y * 2)
        }
    }
    
    func createTile(letter : String) -> Tile{
        let sprite = SKSpriteNode(imageNamed: "tile.png")
        sprite.position = CGPointMake(frame.size.width/2,frame.size.height/2)
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        sprite.physicsBody?.dynamic = true
        self.addChild(sprite)
        
        let t = Tile(sprite:sprite)
        tiles.append(t)
        return t
    }
    
    func setupScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.restitution=0.25 //adds slight bounciness
        motionManager.startAccelerometerUpdates()
        
        self.backgroundColor = UIColor.whiteColor()
        
        let labelText = cat + "  >  " + subcat
        let catLabel = SKLabelNode(text: labelText)
        catLabel.fontColor=UIColor.blackColor()
        
        let length : CGFloat = CGFloat(labelText.characters.count)
        catLabel.position = CGPointMake((length+45)*2, frame.size.height-30)
        addChild(catLabel)
    }
}
