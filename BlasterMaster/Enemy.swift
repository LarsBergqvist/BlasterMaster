//
//  Enemy.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-14.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy : NSObject {
   
    var canFireLaser = false
    var enemySprite:SKSpriteNode?
    var timer = NSTimer()
    
    class func SpriteName() -> String {
        return "enemy"
    }
    
    init(imageName:String,canFire:Bool) {
        super.init()
        
        canFireLaser = canFire
        
        let spTexture = SKTexture(imageNamed: imageName)
        enemySprite = SKSpriteNode(texture: spTexture)
        enemySprite?.name = Enemy.SpriteName()
        
        enemySprite?.physicsBody = SKPhysicsBody(texture: spTexture, size: enemySprite!.size)
        enemySprite?.physicsBody?.dynamic = false
        enemySprite?.physicsBody?.categoryBitMask = enemyBitMask
        enemySprite?.physicsBody?.collisionBitMask = laserShotBitMask
        enemySprite?.physicsBody?.contactTestBitMask = laserShotBitMask
        
        enemySprite?.physicsBody?.dynamic = true
        enemySprite?.physicsBody?.allowsRotation = false

        if (canFire) {
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("fireGun"), userInfo: nil, repeats: true)
        }
    }
    
    func fireGun() {
        if (enemySprite != nil && enemySprite!.parent != nil) {
            if (enemySprite?.name == Enemy.SpriteName()) {
                // only fire if sprite is still an enemy, i.e. not when explodiing
                let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPointMake(enemySprite!.position.x,enemySprite!.position.y-enemySprite!.size.height))
                    shot.Shoot()
            }
        }
    }
}