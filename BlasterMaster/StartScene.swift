//
//  StartScene.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-14.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene : SKScene {
    
    let bgMusic = BackGroundMusic()

    override func didMoveToView(view: SKView) {
        bgMusic.playSound()
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        startGame()
    }
    
    func startGame() {        
        bgMusic.StopSound()
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
        
        let scene = GameScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.Fill //AspectFit
        scene.backgroundColor = UIColor.blackColor()
        
        self.scene?.view?.presentScene(scene, transition: transition)
    }


}