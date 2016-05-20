//
//  Music.swift
//  DistractingNumbers
//
//  Created by Diego Aguirre on 5/20/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import SpriteKit

class Music: SKAudioNode {
    
    static func introMusic() -> SKAudioNode {
        let backgroundMusic = SKAudioNode(fileNamed: "menuSound.mp3")
        backgroundMusic.autoplayLooped = true
        return backgroundMusic
    }
    
    static func playRound1() -> SKAudioNode {
        let backgroundMusic = SKAudioNode(fileNamed: "round1.mp3")
        backgroundMusic.autoplayLooped = true
        return backgroundMusic
    }
    
    static func rushRound() -> SKAudioNode {
        return SKAudioNode()
    }
    
    static func gameOver() -> SKAction {
       return SKAction.playSoundFileNamed("gameEnded.wav", waitForCompletion: false)
    }
    
    static func popSound() -> SKAction {
        return SKAction.playSoundFileNamed("pop2.wav", waitForCompletion: false)
    }
}