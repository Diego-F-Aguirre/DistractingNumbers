//
//  GameScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let playTitle = SKSpriteNode(imageNamed: "PlayTitle")
    var numContainer = SKSpriteNode()
    var numContainerArray = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        addChild(Music.introMusic())
        
        spawnNumbersForever()
        
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60)
        backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        addChild(playButton)
        
        playTitle.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 160))
        playTitle.zPosition = 1
        addChild(playTitle)
    }
    
    func spawnNumbers() {
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        let action = SKAction.moveToY(-160, duration: 2.8)
        let rand = CGFloat(arc4random_uniform(5))
        
        numContainer = SKSpriteNode(imageNamed: "CircleTrail")
        numContainer.name = "CircleTrail"
        numContainer.size = CGSize(width: numContainer.frame.width / rand, height: numContainer.frame.height / rand)
        numContainer.anchorPoint = CGPointMake(0, 0)
        numContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        numContainer.runAction(SKAction.repeatActionForever(action))
        numContainer.zPosition = 2
        
        addChild(numContainer)
        numContainerArray.append(numContainer)
    }
    
    func spawnNumbersForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(0.4)])))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                let scene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
    }
}

