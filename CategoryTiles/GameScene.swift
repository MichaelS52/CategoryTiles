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

//IDEAS - make an object, make all the slides childs, then use that to translate it

class Tile{
    var sprite : SKSpriteNode
    var isDocked : Int //0 if its not, 1 if it is, 2 if it cannot be changed
    var word : String
    var letterValue : String
    var slot : SKSpriteNode? = nil
    
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
    
    func setSlot(_ sprite : SKSpriteNode){
        self.slot = sprite
    }
}

class GameScene: SKScene {
    
    var cat = ""
    var subcat = ""
    
    var words = [String]()
    
    var shelf = [Tile?]()//creates an array, length 7
    var tiles = [Tile]()
    var motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        /* startup function */
        print(self.size.width, " , " , self.size.height)
        self.size = view.bounds.size //set the size to the view size
        
        for text in words{
            let characters = [Character](text.characters)
            for ch in characters{
                let t : Tile = createTile(String(ch));
                t.word = text
                let inner = UInt32(20)
                let randX = 100//randomNumber(inner, max: UInt32(frame.width)-inner)
                let randY = 100//randomNumber(inner, max: UInt32(frame.height/2)-inner)
                let randomRotation = arc4random_uniform(360)
                
                t.sprite.position = CGPoint(x: CGFloat(randX), y: CGFloat(randY))
                t.sprite.zRotation = CGFloat(randomRotation)
            }
        }
        
        let shelfBase = SKLabelNode(text: "__  __  __  __  __  __  __")
        shelfBase.fontColor = UIColor.black
        shelfBase.fontSize = 30
        shelfBase.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/10)*6)
        addChild(shelfBase)
        
        setupScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch is began */
        print("touch")
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        
        let touchedNode = self.atPoint(positionInScene)
        print("name: ", touchedNode.name)
        if(touchedNode.name == "back"){
            print("Back")
            //let scene = MenuScene(fileNamed: "MenuScene")
            //scene?.initialize(cat)
            //view?.presentScene(scene)
        }
        
        for t in tiles{
            if(touchedNode.isEqual(to: t.sprite)){
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
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if let accData = motionManager.accelerometerData{
            physicsWorld.gravity = CGVector(dx: accData.acceleration.x * 2, dy: accData.acceleration.y * 2)
        }
    }
    
    func createTile(_ letter : String) -> Tile{
        let tileFile = letter + ".png"
        let sprite = SKSpriteNode(imageNamed: tileFile)
        sprite.position = CGPoint(x: frame.size.width/2,y: frame.size.height/2)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.isDynamic = true
        sprite.zPosition=5
        self.addChild(sprite)
        
        let t = Tile(sprite:sprite,isDocked: 0, word: "word", letterValue: letter)
        tiles.append(t)
        return t
    }
    
    func setupScene(){
        addFinishedSlots()
        let rect : CGRect = CGRect(x: 0, y: 0, width: frame.width, height: (frame.height/10)*6)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        self.physicsBody?.restitution=0.25 //adds slight bounciness
        motionManager.startAccelerometerUpdates()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeHandler(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        self.backgroundColor = UIColor.white
        
        
        let back = SKSpriteNode(imageNamed: "back.png")
        back.position = CGPoint(x: 20, y: frame.height-20)
        back.setScale(0.040)
        back.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(20))
        back.physicsBody?.isDynamic=false
        back.name = "back"
        addChild(back)
        
        let labelText = cat + " / " + subcat
        let catLabel = SKLabelNode(text: labelText)
        catLabel.fontSize = 25
        catLabel.fontColor=UIColor.black
        
        catLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height-30)
        addChild(catLabel)
    }
    
    func swipeHandler(_ gesture: UIGestureRecognizer){
        clearShelf()
    }
    
    //Shelf functions
    func addToShelf(_ t : Tile){
        t.isDocked=2 //make it not touchable
        let firstEmpty = getFirstShelfEmpty();
        if(firstEmpty == -1){
            shelf.append(t)
        }else{
            shelf[firstEmpty] = t
        }
        
        let pos = shelf.index{$0===t} //Gets position of the letter in the array
        var start : CGPoint = CGPoint(x: (view?.bounds.width)!/7-5,y: ((view?.bounds.height)!/10)*6+20)
        start.x+=CGFloat((pos)!*46) //20 is that difference between underlines?
        
        
        /* Total transformations to add to the shelf */
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
        let translate = SKAction.move(to: start, duration: 0.4)
        let rotation = SKAction.rotate(toAngle: 0, duration: 0.4)
        let transformation = SKAction.group([translate,rotation])
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        
        t.sprite.physicsBody?.affectedByGravity = false
        t.sprite.physicsBody?.isDynamic = false
        t.sprite.physicsBody = nil
        
        t.sprite.run(SKAction.sequence([scaleUp,transformation,scaleDown]),completion: {
            t.isDocked = 1
            self.checkShelf()
        })
    }
    
    func sendToSlot(_ t : Tile){
        if(t.slot != nil){
            t.sprite.zPosition = 10 //put it on top so its not under any during animation
            let scaleDown = SKAction.scale(to: 0.5, duration: 1)
            let translate = SKAction.move(to: t.slot!.position, duration: 1)
            let transformation = SKAction.group([scaleDown,translate])
            
            t.sprite.run(transformation,completion: {
                t.isDocked=2
                t.sprite.zPosition = 5 //put it back under
            })
        }
    }
    
    func addFinishedSlots(){
        var startingX : CGFloat = 0
        var yValue : CGFloat = self.size.height-80
        var wordCount = 0
        for w in words{
            if(wordCount%2==0){
                startingX = self.size.width/2+20 //second of the two on row
            }else{
                startingX = 20 // if its the first of the two words
            }
            var pos : CGFloat = 0
            for char in w.characters{
                let empty = addEmptySlot(startingX+pos, y: yValue)
                let t = getATileFromWord(w, letter: String(char))
                t?.setSlot(empty)
                pos+=22
            }
            wordCount+=1
            if(wordCount==2){
                yValue = self.size.height-120
            }
        }
    }
    
    func addEmptySlot(_ x : CGFloat, y : CGFloat) -> SKSpriteNode{
        let empty = SKSpriteNode(imageNamed: "slot.png")
        empty.position = CGPoint(x: x, y: y)
        empty.setScale(CGFloat(0.5))
        empty.zPosition = 0
        print("Adding slot: ", x, " ", y)
        self.addChild(empty)
        return empty
    }
    
    func remFromShelf(_ t : Tile){
        t.isDocked=2
        let pos : Int? = shelf.index{$0===t}
        if(pos != nil){
        shelf[pos!] = nil
        let target = CGPoint(x: t.sprite.position.x, y: t.sprite.position.y-50)
        
        let translate = SKAction.move(to: target, duration: 0.3)
        t.sprite.run(translate, completion: {
            t.sprite.physicsBody = SKPhysicsBody(rectangleOf: t.sprite.size)
            t.sprite.physicsBody?.affectedByGravity = true;
            t.sprite.physicsBody?.isDynamic = true;
            t.isDocked = 0
        })
        }
    }
    
    func remFromShelfWithoutAnimation(_ t : Tile){
        let pos = shelf.index{$0===t}
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
        for t in shelf{
            if(t != nil){
                if (t?.isDocked != 1) {
                    print ("a tile is not in shelf")
                }
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
                                let realSlot = realtile?.slot
                                let regSlot = tile?.slot
                                
                                tile?.slot = realSlot
                                realtile?.slot = regSlot
                            }
                        }
                    }
                }
                for tile in shelf{
                    if(tile != nil){
                        sendToSlot(tile!)
                        remFromShelfWithoutAnimation(tile!)
                    }
                }
            }
        }
    }
    
    func getATileFromWord(_ word : String, letter : String) -> Tile? {
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
    
    func randomNumber(_ min : UInt32, max : UInt32) -> CGFloat{
        print("min ", min)
        print("max ", max)
        let randomNumber = arc4random_uniform(max-min)+min
        return CGFloat(randomNumber)
    }
    
    func initializeData(_ wordArr : [String], category : String, subcategory : String){
        print("initializing GameBoard")
        
        words = wordArr;
        cat = category;
        subcat = subcategory;
    }
}
