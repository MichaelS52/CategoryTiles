//
//  GameScene.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/3/16.
//  Copyright (c) 2016 Michael Sylva. All rights reserved.
//

/*TODO

- When tiles are taken off the shelf, make it a translation at first, so thats its not immediately up to gravity
- Need to totally restructure the shelf system, it is a dynamic sizing array so if you take one off the middle it wont respond correctly
- Double clicking will move the tile up and back down really fast
 
*/
import SpriteKit
import CoreMotion

var cat = "Sports"
var subcat = "Hockey"

var shelf = [Tile?]()//creates an array, length 7
var tiles = [Tile]()
var motionManager = CMMotionManager()


class Tile{
    var sprite : SKSpriteNode
    var isDocked : Int //0 if its not, 1 if it is, 2 if it cannot be changed
    
    init(sprite: SKSpriteNode, isDocked: Int){
        self.sprite = sprite
        self.isDocked = isDocked
    }
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* startup function */
        
        self.size = view.bounds.size //set the size to the view size
        
        /* Create a few test tiles */
        for var i = 1; i<=200; i+=30{
            for var j = 1; j<=100; j+=30{
                let t : Tile = createTile("x");
                t.sprite.position = CGPointMake(CGFloat(i), CGFloat(j))
            }
        }
        
        let shelfBase = SKLabelNode(text: "__  __  __  __  __  __  __")
        shelfBase.fontColor = UIColor.blackColor()
        shelfBase.fontSize = 30
        shelfBase.position = CGPointMake(CGFloat(self.size.width/2), CGFloat(self.size.height/2))
        addChild(shelfBase)
        
        setupScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch is began */
        let touch = touches.first!
        let positionInScene = touch.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(positionInScene)
        for t in tiles{
            if(touchedNode.isEqualToNode(t.sprite)){
                if(t.isDocked==1){
                    remFromShelf(t)
                }else if(t.isDocked==0){
                    if(!isShelfFull()){// make sure shelf is not full
                        addToShelf(t)
                    }
                }
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
        
        let t = Tile(sprite:sprite,isDocked: 0)
        tiles.append(t)
        return t
    }
    
    func setupScene(){
        let rect : CGRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
        self.physicsBody?.restitution=0.25 //adds slight bounciness
        motionManager.startAccelerometerUpdates()
        var swipeRight = UIPanGestureRecognizer(target: self, action: "swipeHandler:")
        swipeRight.cancelsTouchesInView = true
        self.view?.addGestureRecognizer(swipeRight)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let labelText = cat + " > " + subcat
        let catLabel = SKLabelNode(text: labelText)
        catLabel.fontColor=UIColor.blackColor()
        
        let length : CGFloat = CGFloat(labelText.characters.count)
        catLabel.position = CGPointMake((length+45)*2, frame.size.height-30)
        addChild(catLabel)
    }
    
    func swipeHandler(gesture: UIPanGestureRecognizer){
        var startTouch : CGPoint?
        if(gesture.state == UIGestureRecognizerState.Began){
            var began = gesture.locationInView(self.view)
            print("Began: ", began.x, " ", began.y)
            startTouch = CGPointMake(began.x, began.y)
        }
        if(gesture.state == UIGestureRecognizerState.Ended){
            print("ended")
            
            //Check if swipe was intended to clear tiles
            let thresh = CGFloat(50)
            print("start: ", startTouch?.x)
        }
    }
    
    //Shelf functions
    func addToShelf(t : Tile){
        
        let firstEmpty = getFirstShelfEmpty();
        if(firstEmpty == -1){
            shelf.append(t)
        }else{
            shelf[firstEmpty] = t
        }
        
        let pos = shelf.indexOf{$0===t} //Gets position of the letter in the array
        var start : CGPoint = CGPointMake((view?.bounds.width)!/7-5,(view?.bounds.height)!/2+20)
        start.x+=CGFloat((pos)!*46) //20 is that difference between underlines?
        
        t.isDocked=2 //make it not touchable
        
        /* Total transformations to add to the shelf */
        let scaleUp = SKAction.scaleTo(1.3, duration: 0.2)
        let translate = SKAction.moveTo(start, duration: 0.4)
        let rotation = SKAction.rotateToAngle(0, duration: 0.4)
        let transformation = SKAction.group([translate,rotation])
        let scaleDown = SKAction.scaleTo(1, duration: 0.1)
        
        t.sprite.physicsBody?.affectedByGravity = false
        t.sprite.physicsBody?.dynamic = false
        t.sprite.physicsBody = nil
        
        t.sprite.runAction(SKAction.sequence([scaleUp,transformation,scaleDown]),completion: {
          t.isDocked = 1
        })
    }
    
    func remFromShelf(t : Tile){
        let pos = shelf.indexOf{$0===t}
        shelf[pos!] = nil
        let target = CGPointMake(t.sprite.position.x, t.sprite.position.y-75)
        
        t.isDocked=2
        let translate = SKAction.moveTo(target, duration: 1.0)
        t.sprite.runAction(translate, completion: {
            t.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: t.sprite.size)
            t.sprite.physicsBody?.affectedByGravity = true;
            t.sprite.physicsBody?.dynamic = true;
            t.isDocked = 0
        })
    }
    
    //-1 means append
    func getFirstShelfEmpty() -> Int{
        for i in 0 ..< shelf.count {
            let t = shelf[i]
            if(t==nil){
                return i;
            }
        }
        return -1
    }
    
    func isShelfFull() -> Bool {
        if(shelf.count>=7){
            for i in 0 ..< shelf.count{
                let t = shelf[i]
                if(t==nil){
                    return false;
                }
            }
            return true;
        }else{
            return false;
        }
    }
    
    func clearShelf(startX : CGFloat, endX : CGFloat){
        print("clear shelf: ", startX," end: ",endX)
        for i in 0 ..< shelf.count{
            let t = shelf[i]
            if(t?.sprite.position.x > startX && t?.sprite.position.x < endX){
                remFromShelf(t!)
            }
        }
    }
}
