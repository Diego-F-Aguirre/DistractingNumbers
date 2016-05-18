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
    var bear = SKSpriteNode()
    
    var gameOver : Bool?
    var scoreLabel : SKLabelNode?
    var numContainer = SKSpriteNode()
    var numContainerArray = [SKSpriteNode]()
    var numToTouch = 1
    
    override func didMoveToView(view: SKView) {
        
        initializeValues()
        
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1.0)])))
        
        //bear Background
        bear = SKSpriteNode(imageNamed: "bear_1.png")
        bear.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        bear.zPosition = -1
        self.addChild(bear)
        
        //BG Music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
    }
    
    func initializeValues() {
        
        Scores.score = 0
        gameOver = false
        scoreLabel = SKLabelNode(fontNamed: "System")
        scoreLabel?.text = "Score: \(Scores.score)"
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = .whiteColor()
        scoreLabel?.position = CGPoint(x:CGRectGetMinX(self.frame) + 65, y:(CGRectGetMinY(self.frame) + 10));
        self.addChild(scoreLabel!)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            if theNode.name == "Circle" {
                self.removeChildrenInArray([self.nodeAtPoint(location)])
                Scores.score+=1
            }
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnNumbers() {
        
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let action = SKAction.moveToY(-160, duration: 3)
        
        numContainer = SKSpriteNode(imageNamed: "Circle")
        numContainer.name = "Circle"
        numContainer.size = CGSize(width: 72, height: 72)
        numContainer.anchorPoint = CGPointMake(0, 0)
        numContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        numContainer.runAction(SKAction.repeatActionForever(action))
        numContainer.zPosition = 1
        
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
    
    // MARK: - ADD LINE TO TOP OF touchesEnded(_:withEvent))
    //runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    
    override func update(currentTime: CFTimeInterval) {
        //check if game is over
        
        
        
        if gameOver == true {
            highScorePersistence()
            let scene = ScoreScene(size: self.size)
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
            
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
    
    func highScorePersistence() {
        if Scores.score > Scores.highScore as? Int {
            Scores.highScore = Scores.score
            let savedHighScore = Scores.highScore
            NSUserDefaults.standardUserDefaults().setObject(savedHighScore, forKey: "savedHighScore")
        }
    }
}



























