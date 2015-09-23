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
    
    func spawnNewEnemy(targetPoint:CGPoint) {
        
        let imgIdx = Int(arc4random_uniform(UInt32(images.count)))
        let imageName = images[imgIdx]
        var canFire = false
        if (imageName.containsString("Red")) {
            canFire=true
        }
        let enemy = Enemy(imageName: imageName, canFire: canFire)
        
        let sp = enemy.enemySprite!

        parentNode?.addChild(sp)
        
        let dice1 = arc4random_uniform(UInt32(sp.parent!.frame.size.width-sp.size.width))
        

        let startPos = CGPointMake(CGFloat(dice1)+sp.size.width/2,sp.parent!.frame.height+sp.size.height)
        sp.position = startPos
        let speed = Int(arc4random_uniform(3))+3
        let res = GetFinalPosAndAngle(startPos,targetPoint: targetPoint)
        let moveAction = SKAction.moveTo(res.finalPos, duration: NSTimeInterval(speed))
        enemy.finalPos = res.finalPos
        sp.runAction(moveAction)
        
        if (imageName.containsString("ufo")) {
            let rotAction = SKAction.rotateByAngle( CGFloat(2*M_PI), duration: 1.0)
            sp.runAction(SKAction.repeatActionForever(rotAction))
        }
        else {
            sp.zRotation = res.arc
        }
    }
    
    func GetFinalPosAndAngle(startPos:CGPoint,targetPoint:CGPoint) -> (finalPos:CGPoint,arc:CGFloat)
    {
        let dx = targetPoint.x-startPos.x
        let dy = startPos.y-targetPoint.y
        let ratio = (dx)/(dy)
        let x = startPos.x + ratio*(startPos.y)
        let angle = atan2(dx,dy)
        
        return (CGPointMake(x, -100), angle)
    }
    
    let images = ["enemyBlack1","enemyBlack2","enemyBlack3","enemyBlack4","enemyBlack5","enemyRed1","enemyRed2","enemyRed3","enemyRed4","ufoBlue","ufoGreen","ufoRed","ufoYellow"]
    let images2 = ["enemyRed1"]
    
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