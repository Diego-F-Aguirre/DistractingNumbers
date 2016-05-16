//
//  GameScene.swift
//  DistractingNumbers
//
//  Created by Diego Aguirre on 5/16/16.
//  Copyright (c) 2016 home. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    //1
    let background = SKSpriteNode(imageNamed: "BG")
    var block = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        
        background.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        background.zPosition = -1
        addChild(background)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addBlock),SKAction.waitForDuration(1.0)])))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func addBlock() {
        block = SKSpriteNode(imageNamed: "Block")

        let minValue = self.size.width / 8
        let maxValue = self.size.width - 20
        
        
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        block.position = CGPoint(x: spawnPoint, y: self.size.height)
        let action = SKAction.moveToY(-30, duration: NSTimeInterval(actualDuration))
        block.runAction(SKAction.repeatActionForever(action))
        
        let numberLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        numberLabel.text = "4"
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.verticalAlignmentMode = .Center
        numberLabel.zPosition = block.zPosition + 1
        numberLabel.fontSize = 18
        numberLabel.fontColor = UIColor.whiteColor()

       
        numberLabel.removeFromParent()
        addChild(block)
        block.addChild(numberLabel)
       

    }
    
    // MARK: - ADD LINE TO TOP OF touchesEnded(_:withEvent))
    //runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
