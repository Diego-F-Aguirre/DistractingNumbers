//
//  PlayScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit
import UIKit

struct PhysicsCategory {
    static let circle: UInt32 = 0x1 << 0
    static let leftWall: UInt32 = 0x1 << 1
    static let rightWall: UInt32 = 0x1 << 2
    static let randomCircle: UInt32 = 0x1 << 3
}

struct Scores {
    static var score = 0
    static var highScore = NSUserDefaults.standardUserDefaults().objectForKey("savedHighScore")
}

enum RoundState {
    case Round1
    case RushRound
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var gameOver : Bool?
    var scoreLabel : SKLabelNode?
    var health = 3
    var randomNumContainerSet = Set<SKSpriteNode>()
    var numContainer = SKSpriteNode()
    var numContainerArray = [SKSpriteNode]()
    var numToTouch = 1
    var leftBorderWall = SKSpriteNode()
    var rightBorderWall = SKSpriteNode()
    var pushCircle = SKSpriteNode()
    var dampingRate = CGFloat(0)
    var roundState = RoundState.Round1
    var codeExecuted = false
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        
        self.physicsWorld.contactDelegate = self
        
        initializeValues()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.spawnNumbersForever()
            self.spawnRandomNumForever()
        }
        
        leftBarrierWall()
        rightBarrierWall()
        
        Sprites.clawFlash()
        Sprites.clawFlashNode.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        addChild(Sprites.clawFlashNode)
        
        Sprites.bearBG()
        Sprites.bear.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        addChild(Sprites.bear)
        
        addChild(Music.playRound1())
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            if theNode.name == "Circle" {
                self.removeChildrenInArray([self.nodeAtPoint(location)])
                Scores.score+=1
                runAction(Music.popSound())
            }
            if theNode.name == "FakeCircle" {
                health -= 1
                Sprites.clawFlashNode.hidden = false
                runAction(SKAction.sequence([SKAction.waitForDuration(0.15), SKAction.runBlock(Sprites.dismissClawFlash)]))
                runAction(Music.incorrect())
            }
            if roundState == .RushRound {
                for child in self.children as [SKNode] {
                    if child.name == "round1" {
                        self.removeChildrenInArray([child])
                    }
                }
                if !codeExecuted {
                    addChild(Music.rushRound())
                    codeExecuted = true
                }
            }
        }
    }
//    
//    func backGroundMusic() {
//        switch roundState {
//        case .Round1:
//            addChild(Music.playRound1())
//        case .RushRound:
//            addChild(Music.rushRound())
//        }
//    }
    
    func spawnNumbersForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1.3)])))
    }
    
    func spawnRandomNumForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnRandomNumbers),SKAction.waitForDuration(0.5)])))
    }
    
    // Todo: add Score Label to Labels class
    func initializeValues() {
        Scores.score = 0
        gameOver = false
        health = 3
        scoreLabel = SKLabelNode(fontNamed: "System")
        scoreLabel?.text = "Score: \(Scores.score)"
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = .whiteColor()
        scoreLabel?.position = CGPoint(x:CGRectGetMinX(self.frame) + 65, y:(CGRectGetMinY(self.frame) + 10));
        addChild(scoreLabel!)
    }
    
    func spawnRandomNumbers() {
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        //        let action = SKAction.moveToY(-160, duration: 2)
        
        let randomNumContainer = SKSpriteNode(imageNamed: "Circle")
        randomNumContainer.name = "FakeCircle"
        randomNumContainer.size = CGSize(width: 72, height: 72)
        randomNumContainer.anchorPoint = CGPointMake(0, 0)
        randomNumContainer.position = CGPoint(x: spawnPoint, y: self.size.height + 35)
        //        randomNumContainer.runAction(SKAction.repeatActionForever(action))
        randomNumContainer.zPosition = -1
        
        //Physics
        randomNumContainer.physicsBody = SKPhysicsBody(circleOfRadius: randomNumContainer.size.width / 2)
        randomNumContainer.physicsBody?.categoryBitMask = PhysicsCategory.randomCircle
        randomNumContainer.physicsBody?.collisionBitMask = PhysicsCategory.leftWall | PhysicsCategory.rightWall | PhysicsCategory.circle | PhysicsCategory.randomCircle
        randomNumContainer.physicsBody?.contactTestBitMask = PhysicsCategory.leftWall | PhysicsCategory.rightWall | PhysicsCategory.circle | PhysicsCategory.randomCircle
        randomNumContainer.physicsBody?.dynamic = true
        randomNumContainer.physicsBody?.linearDamping = dampingRate
        randomNumContainer.physicsBody?.allowsRotation = false
        
        let randomNumberLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        if numToTouch > 100 {
        randomNumberLabel.text = String(arc4random_uniform(200) + 100)
        } else {
        randomNumberLabel.text = String(arc4random_uniform(100))
        }
        
        randomNumberLabel.name = "Label"
        randomNumberLabel.zPosition = -2
        randomNumberLabel.position = CGPointMake(CGRectGetMidX(numContainer.centerRect) + 36, CGRectGetMidY(numContainer.centerRect) + 36)
        randomNumberLabel.horizontalAlignmentMode = .Center
        randomNumberLabel.verticalAlignmentMode = .Center
        randomNumberLabel.fontColor = UIColor.whiteColor()
        randomNumberLabel.fontSize = 28
        
        addChild(randomNumContainer)
        randomNumContainer.addChild(randomNumberLabel)
        randomNumContainerSet.insert(randomNumContainer)
    }
    
    func spawnNumbers() {
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        //        let action = SKAction.moveToY(-160, duration: 2)
        
        numContainer = SKSpriteNode(imageNamed: "Circle")
        numContainer.name = "Circle"
        numContainer.size = CGSize(width: 72, height: 72)
        numContainer.anchorPoint = CGPointMake(0, 0)
        numContainer.position = CGPoint(x: spawnPoint, y: self.size.height + 35)
        //        numContainer.runAction(SKAction.repeatActionForever(action))
        numContainer.zPosition = 2
        
        //Physics
        numContainer.physicsBody = SKPhysicsBody(circleOfRadius: numContainer.size.width / 2)
        numContainer.physicsBody?.categoryBitMask = PhysicsCategory.circle
        numContainer.physicsBody?.collisionBitMask = PhysicsCategory.leftWall | PhysicsCategory.rightWall | PhysicsCategory.randomCircle | PhysicsCategory.circle
        numContainer.physicsBody?.contactTestBitMask = PhysicsCategory.leftWall | PhysicsCategory.rightWall | PhysicsCategory.randomCircle | PhysicsCategory.circle
        numContainer.physicsBody?.dynamic = true
        numContainer.physicsBody?.allowsRotation = false
        numContainer.physicsBody?.linearDamping = dampingRate
        
        let numberLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        numberLabel.text = "\(numToTouch)"
        numberLabel.name = "Label"
        numberLabel.zPosition = -1
        numberLabel.position = CGPointMake(CGRectGetMidX(numContainer.centerRect) + 36, CGRectGetMidY(numContainer.centerRect) + 36)
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.verticalAlignmentMode = .Center
        numberLabel.fontColor = UIColor.whiteColor()
        numberLabel.fontSize = 28
        
        addChild(numContainer)
        numContainer.addChild(numberLabel)
        numContainerArray.append(numContainer)
        numToTouch += 1
    }
    
    func leftBarrierWall() {
        leftBorderWall.color = UIColor.purpleColor()
        leftBorderWall.name = "LeftBorderWall"
        leftBorderWall.zPosition = 1
        leftBorderWall.size = CGSize(width: 20, height: CGRectGetMaxY(self.view!.frame) + 75)
        leftBorderWall.position = CGPoint(x: CGRectGetMinX(self.view!.frame) - 10, y: CGRectGetMidY(self.view!.frame))
        
        //Physics
        leftBorderWall.physicsBody = SKPhysicsBody(rectangleOfSize: leftBorderWall.size)
        leftBorderWall.physicsBody?.categoryBitMask = PhysicsCategory.leftWall
        leftBorderWall.physicsBody?.contactTestBitMask = PhysicsCategory.circle | PhysicsCategory.randomCircle
        leftBorderWall.physicsBody?.collisionBitMask = PhysicsCategory.circle | PhysicsCategory.randomCircle
        leftBorderWall.physicsBody?.affectedByGravity = false
        leftBorderWall.physicsBody?.dynamic = false
        
        
        addChild(leftBorderWall)
    }
    
    func rightBarrierWall() {
        rightBorderWall.color = UIColor.purpleColor()
        rightBorderWall.name = "RightBorderWall"
        rightBorderWall.zPosition = 1
        rightBorderWall.size = CGSize(width: 20, height: CGRectGetMaxY(self.view!.frame) + 75)
        rightBorderWall.position = CGPoint(x: CGRectGetMaxX(self.view!.frame) + 10, y: CGRectGetMidY(self.view!.frame))
        
        //Physics
        rightBorderWall.physicsBody = SKPhysicsBody(rectangleOfSize: rightBorderWall.size)
        rightBorderWall.physicsBody?.categoryBitMask = PhysicsCategory.rightWall
        rightBorderWall.physicsBody?.contactTestBitMask = PhysicsCategory.circle | PhysicsCategory.randomCircle
        rightBorderWall.physicsBody?.collisionBitMask = PhysicsCategory.circle | PhysicsCategory.randomCircle
        rightBorderWall.physicsBody?.affectedByGravity = false
        rightBorderWall.physicsBody?.dynamic = false
        
        
        addChild(rightBorderWall)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node as! SKSpriteNode
        let secondBody = contact.bodyB.node as! SKSpriteNode
        
        switch SKSpriteNode() {
        case (firstBody.name == "LeftBorderWall") && (secondBody.name == "Circle"):
            collisionWall(secondBody)
        case (firstBody.name == "Circle") && (secondBody.name == "LeftBorderWall"):
            collisionWall(firstBody)
        case (firstBody.name == "RightBorderWall") && (secondBody.name == "Circle"):
            collisionWall(secondBody)
        case (firstBody.name == "Circle") && (secondBody.name == "RightBorderWall"):
            collisionWall(firstBody)
        case (firstBody.name == "Circle") && (secondBody.name == "RandomCircle"):
            collisionBall(firstBody, pushCircle: secondBody)
        case (firstBody.name == "RandomCircle") && (secondBody.name == "Circle"):
            collisionBall(secondBody, pushCircle: firstBody)
        case (firstBody.name == "RandomCircle") && (secondBody.name == "LeftBorderWall"):
            collisionWall(firstBody)
        case (firstBody.name == "LeftBorderWall") && (secondBody.name == "RandomCircle"):
            collisionWall(secondBody)
        case (firstBody.name == "RandomCircle") && (secondBody.name == "RightBorderWall"):
            collisionWall(firstBody)
        case (firstBody.name == "RightBorderWall") && (secondBody.name == "RandomCircle"):
            collisionWall(secondBody)
        case (firstBody.name == "RandomCircle") && (secondBody.name == "RandomCircle"):
            collisionBall(firstBody, pushCircle: secondBody)
        default:
            return
        }
    }
    
    func collisionWall(circle: SKSpriteNode) {
        circle.physicsBody?.affectedByGravity = true
        circle.physicsBody?.dynamic = true
    }
    
    func collisionBall(circle: SKSpriteNode, pushCircle: SKSpriteNode) {
        circle.physicsBody?.affectedByGravity = true
        circle.physicsBody?.dynamic = true
        circle.physicsBody?.restitution = 0.9
        
        pushCircle.physicsBody?.affectedByGravity = true
        pushCircle.physicsBody?.dynamic = true
        pushCircle.physicsBody?.restitution = 0.9
        //pushCircle.physicsBody?.linearDamping = 25
    }
    
    func evictOffScreenRandomNumNodes() {
        let results = randomNumContainerSet.filter({$0.position.y < -$0.size.height / 2.0})
        
        results.forEach { (node) in
            node.removeFromParent()
            randomNumContainerSet.remove(node)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if gameOver == true || health == 0{
            highScorePersistence()
            gameOverScene()
        }
        if Scores.score == 50 {
            roundState = .RushRound
        }
        
        switch Scores.score {
        case 0...10:
            dampingRate = CGFloat(8)
        case 11...20:
            dampingRate = CGFloat(6)
        case 21...30:
            dampingRate = CGFloat(4)
        case 31...50:
            dampingRate = CGFloat(3)
        case 51...70:
            dampingRate = CGFloat(2)
        case 71...90:
            dampingRate = CGFloat(1.5)
        case 91...110:
            dampingRate = CGFloat(1)
        case 111...130:
            dampingRate = CGFloat(0.5)
        case 131...150:
            dampingRate = CGFloat(0.5)
        case 151...170:
            dampingRate = CGFloat(0.5)
        case 171...190:
            dampingRate = CGFloat(0.5)
        case 191...210:
            dampingRate = CGFloat(0.5)
        case 211...1000:
            dampingRate = CGFloat(0.5)
        default:
            dampingRate = CGFloat(0.5)
        }
        
        checkIfNumHitTheBottom()
        updateScoreLabel()
        evictOffScreenRandomNumNodes()
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "Score: \(Scores.score)"
    }
    
    func checkIfNumHitTheBottom() {
        for node in numContainerArray {
            if node.position.y < -node.size.height / 2.0 {
                node.removeFromParent()
                gameOver = true
            }
        }
    }
    
    func gameOverScene() {
        let scene = ScoreScene(size: self.size)
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }
    
    func highScorePersistence() {
        if Scores.score > Scores.highScore as? Int {
            Scores.highScore = Scores.score
            let savedHighScore = Scores.highScore
            NSUserDefaults.standardUserDefaults().setObject(savedHighScore, forKey: "savedHighScore")
        }
    }
}



























