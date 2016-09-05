//
//  GameScene.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/3/16.
//  Copyright (c) 2016 Michael Sylva. All rights reserved.
//

import SpriteKit
import CoreMotion

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
        let t = createTile("x")
        
        let t2 = createTile("x")
        t2.sprite.position.x+=50
        
        let t3 = createTile("x")
        t3.sprite.position.x-=50
        t3.sprite.position.y+=20
        
        /* startup function */
        setupScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch is began */
        
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
    }
}
