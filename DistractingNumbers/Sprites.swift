//
//  Sprites.swift
//  DistractingNumbers
//
//  Created by Diego Aguirre on 5/20/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import SpriteKit

class Sprites: SKSpriteNode {
    
    static var bear = SKSpriteNode()
    static var clawFlashNode = SKSpriteNode()
    static var numContainer = SKSpriteNode()
    static var numContainerArray = [SKSpriteNode]()


    static func bearBG() -> SKSpriteNode {
        bear = SKSpriteNode(imageNamed: "bear_1.png")
        bear.zPosition = -5
        return bear 
    }
    
    static func clawFlash() -> SKSpriteNode {
        clawFlashNode.size = CGSize(width: clawFlashNode.frame.width, height: clawFlashNode.frame.height)
        clawFlashNode = SKSpriteNode(imageNamed: "Claw")
        clawFlashNode.hidden = true
        return clawFlashNode
    }
    
    static func dismissClawFlash() {
        Sprites.clawFlashNode.hidden = true
    }
}
