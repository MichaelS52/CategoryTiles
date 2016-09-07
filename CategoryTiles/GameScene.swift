//
//  GameScene.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/3/16.
//  Copyright (c) 2016 Michael Sylva. All rights reserved.
//

/*TODO

- DONE When tiles are taken off the shelf, make it a translation at first, so thats its not immediately up to gravity
- DONE Need to totally restructure the shelf system, it is a dynamic sizing array so if you take one off the middle it wont respond correctly
- DONE Double clicking will move the tile up and back down really fast
- Add final guess underlines
 
*/
import SpriteKit
import CoreMotion

var cat = ""
var subcat = ""

var words = [String]()

var shelf = [Tile?]()//creates an array, length 7
var tiles = [Tile]()
var motionManager = CMMotionManager()


class Tile{
    var sprite : SKSpriteNode
    var isDocked : Int //0 if its not, 1 if it is, 2 if it cannot be changed
    var word : String
    var letterValue : String
    
    init(sprite: SKSpriteNode, isDocked: Int, word: String, letterValue: String){
        self.sprite = sprite
        self.isDocked = isDocked
        self.word = word
        self.letterValue = letterValue
    }
    
    func debugPrint(){
        print("Tile - ",self.letterValue)
        print("word: ",self.word)
        print("isDocked: ",self.isDocked)
        print("sprite: ",self.sprite.hash)
    }
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* startup function */
        print(self.size.width, " , " , self.size.height)
        self.size = view.bounds.size //set the size to the view size
        
        for text in words{
            let characters = [Character](text.characters)
            for ch in characters{
                let t : Tile = createTile(String(ch));
                t.word = text
                let inner = UInt32(20)
                let randX = randomNumber(inner, max: UInt32(frame.width)-inner)
                let randY = randomNumber(inner, max: UInt32(frame.height/2)-inner)
                let randomRotation = arc4random_uniform(360)
                
                t.sprite.position = CGPointMake(CGFloat(randX), CGFloat(randY))
                t.sprite.zRotation = CGFloat(randomRotation)
            }
        }
        
        let shelfBase = SKLabelNode(text: "__  __  __  __  __  __  __")
        shelfBase.fontColor = UIColor.blackColor()
        shelfBase.fontSize = 30
        shelfBase.position = CGPointMake(CGFloat(self.size.width/2), CGFloat(self.size.height/10)*6)
        addChild(shelfBase)
        
        setupScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch is began */
        let touch = touches.first!
        let positionInScene = touch.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(positionInScene)
        print("name: ", touchedNode.name)
        if(touchedNode.name == "back"){
            if let scene = MenuScene(fileNamed:"MenuScene") {
                // Configure the view.
                let skView = self.view! as! SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                let transition = SKTransition.moveInWithDirection(.Left, duration: 0.5)
                skView.presentScene(scene, transition: transition)
            }

        }
        
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
        let tileFile = letter + ".png"
        let sprite = SKSpriteNode(imageNamed: tileFile)
        sprite.position = CGPointMake(frame.size.width/2,frame.size.height/2)
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        sprite.physicsBody?.dynamic = true
        self.addChild(sprite)
        
        let t = Tile(sprite:sprite,isDocked: 0, word: "word", letterValue: letter)
        tiles.append(t)
        return t
    }
    
    func setupScene(){
        let rect : CGRect = CGRect(x: 0, y: 0, width: frame.width, height: (frame.height/10)*6)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
        self.physicsBody?.restitution=0.25 //adds slight bounciness
        motionManager.startAccelerometerUpdates()
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeHandler:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view?.addGestureRecognizer(swipeDown)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let back = SKSpriteNode(imageNamed: "back.png")
        back.position = CGPointMake(20, frame.height-20)
        back.setScale(0.040)
        back.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(20))
        back.physicsBody?.dynamic=false
        back.name = "back"
        addChild(back)
        
        let labelText = cat + " / " + subcat
        let catLabel = SKLabelNode(text: labelText)
        catLabel.fontSize = 25
        catLabel.fontColor=UIColor.blackColor()
        
        catLabel.position = CGPointMake(frame.size.width/2, frame.size.height-30)
        addChild(catLabel)
    }
    
    func swipeHandler(gesture: UIGestureRecognizer){
        clearShelf()
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
        var start : CGPoint = CGPointMake((view?.bounds.width)!/7-5,((view?.bounds.height)!/10)*6+20)
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
            self.checkShelf()
        })
    }
    
    func remFromShelf(t : Tile){
        let pos = shelf.indexOf{$0===t}
        shelf[pos!] = nil
        let target = CGPointMake(t.sprite.position.x, t.sprite.position.y-50)
        
        t.isDocked=2
        let translate = SKAction.moveTo(target, duration: 0.3)
        t.sprite.runAction(translate, completion: {
            t.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: t.sprite.size)
            t.sprite.physicsBody?.affectedByGravity = true;
            t.sprite.physicsBody?.dynamic = true;
            t.isDocked = 0
        })
    }
    
    func remFromShelfWithoutAnimation(t : Tile){
        let pos = shelf.indexOf{$0===t}
        shelf[pos!] = nil
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
    
    func clearShelf(){
        for i in 0 ..< shelf.count{
            let t : Tile? = shelf[i]
            if(t != nil){
                remFromShelf(t!)
            }
        }
    }
    
    func checkShelf(){
        var shelfSpelt = ""
        for tile in shelf{
            if(tile != nil){
                shelfSpelt += (tile?.letterValue)!
            }
        }
        for w in words{
            if(shelfSpelt == w){
                for tile in shelf {
                    if(tile != nil){
                        if(tile!.word != shelfSpelt){
                            let realtile : Tile? = self.getATileFromWord(shelfSpelt, letter: tile!.letterValue)
                            if(realtile != nil){
                                realtile?.word = (tile?.word)!
                                tile?.word = shelfSpelt
                            }
                        }
                    }
                }
                for tile in shelf{
                    if(tile != nil){
                        remFromShelfWithoutAnimation(tile!)
                        tile?.sprite.removeFromParent()
                    }
                }
            }
        }
    }
    
    func getATileFromWord(word : String, letter : String) -> Tile? {
        print("looking for letter :", word, letter)
        for tile in tiles{
            if(tile.word == word){
                if(tile.letterValue == letter){
                    print("found letter!")
                    return tile;
                }
            }

        }
        return nil;
    }
    
    func randomNumber(min : UInt32, max : UInt32) -> CGFloat{
        print("min ", min)
        print("max ", max)
        let randomNumber = arc4random_uniform(max-min)+min
        return CGFloat(randomNumber)
    }
    
    func initializeData(wordArr : [String], category : String, subcategory : String){
        print("initializing GameBoard")
        words = wordArr;
        cat = category;
        subcat = subcategory;
    }
}
