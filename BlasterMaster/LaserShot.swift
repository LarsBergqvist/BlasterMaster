//
//  LaserShot.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-14.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit

class LaserShot {
    
    class func SpriteName() -> String {
        return "lasershot"
    }

    var laserSprite = SKSpriteNode(imageNamed: "laserBlue01")
    var parent:SKNode?
    var position:CGPoint = CGPointMake(0, 0)
    
    init(parentNode:SKNode, pos:CGPoint) {
        parent = parentNode
        position = pos
        
        let spTexture = SKTexture(imageNamed: "laserBlue01")
        laserSprite = SKSpriteNode(texture: spTexture!)
        laserSprite.physicsBody = SKPhysicsBody(texture: spTexture, size: laserSprite.size)
        laserSprite.physicsBody?.dynamic = true
        laserSprite.physicsBody?.allowsRotation = false
        laserSprite.name = LaserShot.SpriteName()

        
        laserSprite.physicsBody?.categoryBitMask = laserShotBitMask
        laserSprite.physicsBody?.collisionBitMask = enemyBitMask
        laserSprite.physicsBody?.contactTestBitMask = enemyBitMask


    }
    
    func Shoot() -> Void {
        laserSprite.position = self.position
        
        parent?.addChild(laserSprite)
        var finalPos = laserSprite.parent?.frame.height
        var moveAction = SKAction.moveByX(0, y: finalPos!+200.0, duration: 0.7)
        moveAction.timingMode = SKActionTimingMode.EaseInEaseOut
        laserSprite.runAction(moveAction)
    }
    
}
