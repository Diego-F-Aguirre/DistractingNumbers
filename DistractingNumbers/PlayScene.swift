//
//  PlayScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    
    var score = 0
    var gameOver : Bool?
    var scoreLabel : SKLabelNode?
    var numContainer = SKSpriteNode()
    var numContainerArray = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        
        initializeValues()
        
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1.0)])))
        
//        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
//        backgroundMusic.autoplayLooped = true
//        addChild(backgroundMusic)
        
    }
    
    func initializeValues() {
        
        score = 0
        gameOver = false
        scoreLabel = SKLabelNode(fontNamed: "System")
        scoreLabel?.text = "Score: \(score)"
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
                score+=1
            }
            if gameOver == true {
                print("game over")
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
        numberLabel.text = "77"
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
    }
    
    // MARK: - ADD LINE TO TOP OF touchesEnded(_:withEvent))
    //runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    
    override func update(currentTime: CFTimeInterval) {
        //check if game is over
        
        if gameOver == true {

            
        }
        
        checkIfNumHitTheBottom()
        updateScoreLabel()
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "Score: \(score)"
    }
    
    func gameOverfunc() {
        print("you lose")
    }
    
    func checkIfNumHitTheBottom() {
        for node in numContainerArray {
            if node.position.y < -node.size.height / 2.0 {
                node.removeFromParent()
                gameOver = true
            }
        }
    }
}



























