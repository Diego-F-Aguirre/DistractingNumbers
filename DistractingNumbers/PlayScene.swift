//
//  PlayScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    
    
    //let background = SKSpriteNode(imageNamed: "BG")
    //var block = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = .whiteColor()
        
        //        background.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        //        background.zPosition = -1
        //        addChild(background)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(1.0)])))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "Destroyable" {
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
        let action = SKAction.moveToY(-30, duration: NSTimeInterval(actualDuration))
        
        let numContainer = SKShapeNode(rectOfSize: CGSize(width: 50, height: 50))
        numContainer.name = "Destroyable"
        numContainer.fillColor = .blackColor()
        numContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        numContainer.runAction(SKAction.repeatActionForever(action))
        
        let numberLabel = SKLabelNode(text: "4")
        numberLabel.fontName = "Chalkduster"
        numberLabel.name = "Destroyable"
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.verticalAlignmentMode = .Center
        //numberLabel.zPosition = block.zPosition + 1
        numberLabel.fontColor = UIColor.whiteColor()
        numberLabel.fontSize = 18
        numberLabel.fontColor = UIColor.whiteColor()
        
        
        //numberLabel.removeFromParent()
        addChild(numContainer)
        numContainer.addChild(numberLabel)
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


