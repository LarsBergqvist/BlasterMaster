//
//  EnemyShot.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-14.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyShot {

    class func SpriteName() -> String {
        return "enemyshot"
    }

    var laserSprite = SKSpriteNode(imageNamed: "laserRed13")
    var parent:SKNode?
    var position:CGPoint = CGPoint(x: 0, y: 0)
    
    init(parentNode:SKNode, pos:CGPoint) {
        parent = parentNode
        position = pos
        
        let spTexture = SKTexture(imageNamed: "laserRed13")
        laserSprite = SKSpriteNode(texture: spTexture)
//        laserSprite.physicsBody = SKPhysicsBody(circleOfRadius: laserSprite.size.height/2)
        
        laserSprite.physicsBody = SKPhysicsBody(texture: spTexture, size: laserSprite.size)
        laserSprite.physicsBody?.isDynamic = true
        laserSprite.physicsBody?.allowsRotation = false
        laserSprite.name = EnemyShot.SpriteName()
        
        laserSprite.physicsBody?.categoryBitMask = enemyShotBitMask
        laserSprite.physicsBody?.collisionBitMask = playerBitMask
        laserSprite.physicsBody?.contactTestBitMask = playerBitMask
    }
    
    func Shoot(_ finalPos:CGPoint) -> Void {
        laserSprite.position = self.position
        
        parent?.addChild(laserSprite)
        let moveAction = SKAction.move(to: finalPos, duration: 0.5)
        let arc = atan2(finalPos.x-position.x,position.y-finalPos.y)
        laserSprite.zRotation = arc
        moveAction.timingMode = SKActionTimingMode.easeInEaseOut
        laserSprite.run(moveAction)
    }
    
}
