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
        
        var imgIdx = Int(arc4random_uniform(UInt32(images.count)))
        var imageName = images[imgIdx]
        var canFire = false
        if (imageName == "enemyRed1" || imageName == "ufoRed") {
            canFire=true
        }
        var enemy = Enemy(imageName: imageName, canFire: canFire)
        
        var sp = enemy.enemySprite!

        parentNode?.addChild(sp)
        
        var dice1 = arc4random_uniform(UInt32(sp.parent!.frame.size.width-sp.size.width))
        

        sp.position = CGPointMake(CGFloat(dice1)+sp.size.width/2,sp.parent!.frame.height+sp.size.height)
        var speed = Int(arc4random_uniform(3))+3
        var moveAction = SKAction.moveToY(-100, duration: NSTimeInterval(speed))
        sp.runAction(moveAction)
        
        if (imageName == "ufoBlue" || imageName == "ufoRed" || imageName == "ufoGreen" || imageName == "ufoYellow") {
            var rotAction = SKAction.rotateByAngle( CGFloat(2*M_PI), duration: 1.0)
            sp.runAction(SKAction.repeatActionForever(rotAction))
        }
    }
    
    let images = ["enemyBlack1","enemyBlack2","enemyBlack3","enemyBlack4","enemyBlack5","enemyRed1","ufoBlue","ufoGreen","ufoRed","ufoYellow"]
    
    func removeEnemiesOutsideScreen() {
        parentNode?.enumerateChildNodesWithName("*") {
            node,stop in
            if let name = node.name {
                if (name == "enemy" || name == "enemyshot") {
                    var finalPos = -80.0
                    
                    if (node.position.y <= CGFloat(finalPos)) {
                        node.removeFromParent()
                    }
                }
            }
        }
        
    }

}