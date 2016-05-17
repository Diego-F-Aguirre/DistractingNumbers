//
//  PlayScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1.0)])))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "Destroyable" || theName == "Label" {
                    self.removeChildrenInArray([self.nodeAtPoint(location)])
                    print("tapped")
                }
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
        let maxValue = self.size.width - 20
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let action = SKAction.moveToY(-160, duration: NSTimeInterval(actualDuration))
        
        let numbContainer = SKSpriteNode(imageNamed: "Circle")
        numbContainer.name = "Destroyable"
        numbContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        numbContainer.runAction(SKAction.repeatActionForever(action))
        
        let numberLabel = SKLabelNode(text: "77")
        numberLabel.fontName = "AvenirNext-Bold"
        numberLabel.name = "Label"
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.verticalAlignmentMode = .Center
        numberLabel.fontColor = UIColor.whiteColor()
        numberLabel.fontSize = 50
        
        addChild(numbContainer)
        numbContainer.addChild(numberLabel)
    }
    
    // MARK: - ADD LINE TO TOP OF touchesEnded(_:withEvent))
    //runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


