//
//  EnemySpawner.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-14.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit

class EnemySpawner: NSObject {
    var parentNode:SKNode?
    
    init(parent:SKNode) {
        parentNode = parent
    }
    
    func spawnNewEnemy() {
        
        let imgIdx = Int(arc4random_uniform(UInt32(images.count)))
        let imageName = images[imgIdx]
        var canFire = false
        if (imageName == "enemyRed1" || imageName == "ufoRed") {
            canFire=true
        }
        let enemy = Enemy(imageName: imageName, canFire: canFire)
        
        let sp = enemy.enemySprite!

        parentNode?.addChild(sp)
        
        let dice1 = arc4random_uniform(UInt32(sp.parent!.frame.size.width-sp.size.width))
        

        sp.position = CGPointMake(CGFloat(dice1)+sp.size.width/2,sp.parent!.frame.height+sp.size.height)
        let speed = Int(arc4random_uniform(3))+3
        let moveAction = SKAction.moveToY(-100, duration: NSTimeInterval(speed))
        sp.runAction(moveAction)
        
        if (imageName == "ufoBlue" || imageName == "ufoRed" || imageName == "ufoGreen" || imageName == "ufoYellow") {
            let rotAction = SKAction.rotateByAngle( CGFloat(2*M_PI), duration: 1.0)
            sp.runAction(SKAction.repeatActionForever(rotAction))
        }
    }
    
    let images = ["enemyBlack1","enemyBlack2","enemyBlack3","enemyBlack4","enemyBlack5","enemyRed1","ufoBlue","ufoGreen","ufoRed","ufoYellow"]
    
    func removeEnemiesOutsideScreen() {
        parentNode?.enumerateChildNodesWithName("*") {
            node,stop in
            if let name = node.name {
                if (name == Enemy.SpriteName() || name == EnemyShot.SpriteName()) {
                    let finalPos = -80.0
                    
                    if (node.position.y <= CGFloat(finalPos)) {
                        node.removeFromParent()
                    }
                }
            }
        }
        
    }

}