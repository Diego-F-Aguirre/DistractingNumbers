//
//  PlayScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit
import UIKit

struct Scores {
    static var score = 0
    static var highScore = NSUserDefaults.standardUserDefaults().objectForKey("savedHighScore")
}

struct PhysicsCategory {
    static let circle: UInt32 = 0x1 << 0
    static let randomCircle: UInt32 = 0x1 << 1
    static let leftWall: UInt32 = 0x1 << 2
    static let rightWall: UInt32 = 0x1 << 3
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var bear = SKSpriteNode()
    var clawFlashNode = SKSpriteNode()
    var leftBorderWall = SKSpriteNode()
    var rightBorderWall = SKSpriteNode()
    
    var gameOver : Bool?
    var scoreLabel : SKLabelNode?
    var health = 3
    var numContainer = SKSpriteNode()
    var numContainerArray = [SKSpriteNode]()
    var numToTouch = 1
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        
        initializeValues()
        spawnNumbersForever()
        clawFlash()
        
        leftBarrierWall()
        rightBarrierWall()
    
        spawnRandomNumForever()
    
        //bear Background
        bear = SKSpriteNode(imageNamed: "bear_1.png")
        bear.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        bear.zPosition = -5
        self.addChild(bear)
        
        //BG Play Scene Music
        let backgroundMusic = SKAudioNode(fileNamed: "round1.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            if theNode.name == "Circle" {
                self.removeChildrenInArray([self.nodeAtPoint(location)])
                Scores.score+=1
                runAction(SKAction.playSoundFileNamed("pop2.wav", waitForCompletion: false))
            }
            if theNode.name == "FakeCircle" {
                health -= 1
                clawFlashNode.hidden = false
                runAction(SKAction.sequence([SKAction.waitForDuration(0.15), SKAction.runBlock(dismissClawFlash)]))
                runAction(SKAction.playSoundFileNamed("incorrect2.wav", waitForCompletion: false))
            }
        }
    }
    
    func clawFlash() {
        clawFlashNode.size = CGSize(width: clawFlashNode.frame.width, height: clawFlashNode.frame.height)
        clawFlashNode = SKSpriteNode(imageNamed: "Claw")
        clawFlashNode.hidden = true
        clawFlashNode.position = CGPoint(x: CGRectGetMidX(view!.frame), y: CGRectGetMidY(view!.frame))
        
        addChild(clawFlashNode)
    }
    
    func dismissClawFlash() {
        clawFlashNode.hidden = true
    }
    
    func spawnNumbersForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1)])))
    }
    
    func spawnRandomNumForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnRandomNumbers),SKAction.waitForDuration(0.5)])))
    }
    
    func initializeValues() {
        
        Scores.score = 0
        gameOver = false
        health = 3
        scoreLabel = SKLabelNode(fontNamed: "System")
        scoreLabel?.text = "Score: \(Scores.score)"
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = .whiteColor()
        scoreLabel?.position = CGPoint(x:CGRectGetMinX(self.frame) + 65, y:(CGRectGetMinY(self.frame) + 10));
        self.addChild(scoreLabel!)
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnRandomNumbers() {
        
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
//        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let action = SKAction.moveToY(-160, duration: 2)
        
        let randomNumContainer = SKSpriteNode(imageNamed: "Circle")
        randomNumContainer.name = "FakeCircle"
        randomNumContainer.size = CGSize(width: 72, height: 72)
        randomNumContainer.anchorPoint = CGPointMake(0, 0)
        let position = CGPoint(x: spawnPoint, y: self.size.height)
        randomNumContainer.position = position
        randomNumContainer.runAction(SKAction.repeatActionForever(action))
        randomNumContainer.zPosition = -1
        randomNumContainer.physicsBody?.collisionBitMask = 0
        
        
        //Physics
        randomNumContainer.physicsBody = SKPhysicsBody(circleOfRadius: randomNumContainer.size.width + 3)
        randomNumContainer.physicsBody?.categoryBitMask = PhysicsCategory.randomCircle
        randomNumContainer.physicsBody?.collisionBitMask = PhysicsCategory.circle | PhysicsCategory.leftWall | PhysicsCategory.rightWall
        randomNumContainer.physicsBody?.contactTestBitMask = PhysicsCategory.circle | PhysicsCategory.leftWall | PhysicsCategory.rightWall
        randomNumContainer.physicsBody?.usesPreciseCollisionDetection = true
        randomNumContainer.physicsBody?.dynamic = true
        randomNumContainer.physicsBody?.affectedByGravity = false
        randomNumContainer.physicsBody?.restitution = 0.4
        randomNumContainer.physicsBody?.allowsRotation = false
        
        let randomNumberLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        randomNumberLabel.text = String(arc4random_uniform(100))
        randomNumberLabel.name = "Label"
        randomNumberLabel.zPosition = -2
        randomNumberLabel.position = CGPointMake(CGRectGetMidX(numContainer.centerRect) + 36, CGRectGetMidY(numContainer.centerRect) + 36)
        randomNumberLabel.horizontalAlignmentMode = .Center
        randomNumberLabel.verticalAlignmentMode = .Center
        randomNumberLabel.fontColor = UIColor.whiteColor()
        randomNumberLabel.fontSize = 28
        
        if positionIsEmpty(position) {
            randomNumContainer.position = position
            addChild(randomNumContainer)
            randomNumContainer.addChild(randomNumberLabel)
        }
        
    }
    
    func spawnNumbers() {
        
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
//        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let action = SKAction.moveToY(-160, duration: 2)
        
        numContainer = SKSpriteNode(imageNamed: "Circle")
        numContainer.name = "Circle"
        numContainer.size = CGSize(width: 72, height: 72)
        numContainer.anchorPoint = CGPointMake(0, 0)
        let position = CGPoint(x: spawnPoint, y: self.size.height)
        numContainer.position = position
        numContainer.runAction(SKAction.repeatActionForever(action))
        numContainer.zPosition = 2
        numContainer.physicsBody?.collisionBitMask = 0
        
        //Physics
        numContainer.physicsBody = SKPhysicsBody(circleOfRadius: numContainer.size.width + 3)
        numContainer.physicsBody?.categoryBitMask = PhysicsCategory.circle
        numContainer.physicsBody?.collisionBitMask = PhysicsCategory.randomCircle | PhysicsCategory.leftWall | PhysicsCategory.rightWall
        numContainer.physicsBody?.contactTestBitMask = PhysicsCategory.randomCircle | PhysicsCategory.leftWall | PhysicsCategory.rightWall
        numContainer.physicsBody?.usesPreciseCollisionDetection = true
        numContainer.physicsBody?.dynamic = true
        numContainer.physicsBody?.affectedByGravity = false
        numContainer.physicsBody?.restitution = 0.4
        numContainer.physicsBody?.allowsRotation = false
        
        let numberLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        numberLabel.text = "\(numToTouch)"
        numberLabel.name = "Label"
        numberLabel.zPosition = -1
        numberLabel.position = CGPointMake(CGRectGetMidX(numContainer.centerRect) + 36, CGRectGetMidY(numContainer.centerRect) + 36)
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.verticalAlignmentMode = .Center
        numberLabel.fontColor = UIColor.whiteColor()
        numberLabel.fontSize = 28
        
        if positionIsEmpty(position) {
            numContainer.position = position
            addChild(numContainer)
            numContainer.addChild(numberLabel)
            numContainerArray.append(numContainer)
            numToTouch += 1
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        //check if game is over
        
        if gameOver == true || health == 0{
            highScorePersistence()
            gameOverScene()
        }
        
        checkIfNumHitTheBottom()
        updateScoreLabel()
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
    
    func positionIsEmpty(point: CGPoint) -> Bool {
        self.enumerateChildNodesWithName("dotted", usingBlock: {
            node, stop in
            
            let dot = node as! SKSpriteNode
            if (CGRectContainsPoint(dot.frame, point)) {
                return
            }
        })
        return true
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody = contact.bodyA.node as! SKSpriteNode
        let secondBody = contact.bodyB.node as! SKSpriteNode
        
        if ((firstBody.name == "Circle") && (secondBody.name == "RandomCircle")) {
            collisionBall(firstBody, circle2: secondBody)
        } else if ((firstBody.name == "RandomCircle") && (secondBody.name == "Circle")) {
            collisionBall(secondBody, circle2: firstBody)
        } else if ((firstBody.name == "RandomCircle") && (secondBody.name == "LeftBorderWall")) {
            collisionWall(firstBody)
        } else if ((firstBody.name == "RandomCircle") && (secondBody.name == "RightBorderWall")) {
            collisionWall(firstBody)
        } else if ((firstBody.name == "RightBorderWall") && (secondBody.name == "RandomCircle")) {
            collisionWall(firstBody)
        } else if ((firstBody.name == "LeftBorderWall") && (secondBody.name == "RandomCircle")) {
            collisionWall(firstBody)
        }else if ((firstBody.name == "LeftBorderWall") && (secondBody.name == "Circle")) {
            collisionWall(secondBody)
        } else if ((firstBody.name == "Circle") && (secondBody.name == "LeftBorderWall")) {
            collisionWall(firstBody)
        } else if ((firstBody.name == "RightBorderWall") && (secondBody.name == "Circle")) {
            collisionWall(secondBody)
        } else if ((firstBody.name == "Circle") && (secondBody.name == "RightBorderWall")) {
            collisionWall(firstBody)
        }
        
    }
    
    func collisionBall(circle1: SKSpriteNode, circle2: SKSpriteNode) {
        circle1.physicsBody?.affectedByGravity = true
        circle1.physicsBody?.dynamic = true
        
        circle2.physicsBody?.affectedByGravity = true
        circle2.physicsBody?.dynamic = true
    }
    
    func collisionWall(circle: SKSpriteNode) {
        circle.physicsBody?.affectedByGravity = true
        circle.physicsBody?.dynamic = true
    }
    
    func leftBarrierWall() {
        leftBorderWall.color = UIColor.purpleColor()
        leftBorderWall.name = "LeftBorderWall"
        leftBorderWall.zPosition = 1
        leftBorderWall.size = CGSize(width: 20, height: CGRectGetMaxY(self.view!.frame))
        leftBorderWall.position = CGPoint(x: CGRectGetMinX(self.view!.frame) - 5, y: CGRectGetMidY(self.view!.frame))
        
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
        rightBorderWall.size = CGSize(width: 20, height: CGRectGetMaxY(self.view!.frame))
        rightBorderWall.position = CGPoint(x: CGRectGetMaxX(self.view!.frame) + 5, y: CGRectGetMidY(self.view!.frame))
        
        //Physics
        rightBorderWall.physicsBody = SKPhysicsBody(rectangleOfSize: rightBorderWall.size)
        rightBorderWall.physicsBody?.categoryBitMask = PhysicsCategory.rightWall
        rightBorderWall.physicsBody?.contactTestBitMask = PhysicsCategory.circle | PhysicsCategory.randomCircle
        rightBorderWall.physicsBody?.collisionBitMask = PhysicsCategory.circle | PhysicsCategory.randomCircle
        rightBorderWall.physicsBody?.affectedByGravity = false
        rightBorderWall.physicsBody?.dynamic = false
    
        addChild(rightBorderWall)
    }

}



























