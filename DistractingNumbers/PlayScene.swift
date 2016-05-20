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

class PlayScene: SKScene {
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
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
        spawnRandomNumForever()
        
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
        }
    }
    
    func spawnNumbersForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1.3)])))
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
        addChild(scoreLabel!)
    }
    
    func spawnRandomNumbers() {
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let action = SKAction.moveToY(-160, duration: 2)
        
        let randomNumContainer = SKSpriteNode(imageNamed: "Circle")
        randomNumContainer.name = "FakeCircle"
        randomNumContainer.size = CGSize(width: 72, height: 72)
        randomNumContainer.anchorPoint = CGPointMake(0, 0)
        randomNumContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        randomNumContainer.runAction(SKAction.repeatActionForever(action))
        randomNumContainer.zPosition = -1
        
        let randomNumberLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        randomNumberLabel.text = String(arc4random_uniform(100))
        randomNumberLabel.name = "Label"
        randomNumberLabel.zPosition = -2
        randomNumberLabel.position = CGPointMake(CGRectGetMidX(numContainer.centerRect) + 36, CGRectGetMidY(numContainer.centerRect) + 36)
        randomNumberLabel.horizontalAlignmentMode = .Center
        randomNumberLabel.verticalAlignmentMode = .Center
        randomNumberLabel.fontColor = UIColor.whiteColor()
        randomNumberLabel.fontSize = 28
        
        addChild(randomNumContainer)
        randomNumContainer.addChild(randomNumberLabel)
    }
    
    func spawnNumbers() {
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let action = SKAction.moveToY(-160, duration: 2)
        
        numContainer = SKSpriteNode(imageNamed: "Circle")
        numContainer.name = "Circle"
        numContainer.size = CGSize(width: 72, height: 72)
        numContainer.anchorPoint = CGPointMake(0, 0)
        numContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        numContainer.runAction(SKAction.repeatActionForever(action))
        numContainer.zPosition = 2
        
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
    
    override func update(currentTime: CFTimeInterval) {
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
}



























