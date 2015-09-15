//
//  SpaceShip.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-13.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class SpaceShip : NSObject, AVAudioPlayerDelegate {
    var firePressed:Bool = false
    var moveLeft:Bool = false
    var moveRight:Bool = false
    var speed = Double(0.0)
    let speedFactor = 30.0
    
    let shipSprite:SKSpriteNode = SKSpriteNode(imageNamed: "playerShip1_blue")

    
    func addShipToParent(parent:SKNode, pos:CGPoint) -> Void {
        shipSprite.xScale = 1
        shipSprite.yScale = 1
        shipSprite.position = pos
        
        let spTexture = SKTexture(imageNamed: "playerShip1_blue")

        shipSprite.physicsBody = SKPhysicsBody(texture: spTexture, size: shipSprite.size)
        shipSprite.physicsBody?.dynamic = true
        shipSprite.physicsBody?.allowsRotation = false
        shipSprite.name = "player"

        shipSprite.physicsBody?.categoryBitMask = playerBitMask
        shipSprite.physicsBody?.collisionBitMask = enemyBitMask
        shipSprite.physicsBody?.contactTestBitMask = enemyBitMask

        parent.addChild(shipSprite)
        
    }
    
    let fireRate = 5
    var fireWaitCount = 0
    func updateActions() -> Void {
        if (firePressed) {
            if (fireWaitCount >= fireRate) {
                firePressed = false
                fireLaser()
                fireWaitCount=0
            }
            fireWaitCount++
        }
        if (moveLeft) {
            if (shipSprite.position.x > 0 ) {
                shipSprite.position.x -= CGFloat(speedFactor)*CGFloat(speed)
            }
        }
        if (moveRight) {
            if (shipSprite.position.x < shipSprite.parent?.frame.width ) {
                shipSprite.position.x += CGFloat(speedFactor)*CGFloat(speed)
            }
        }
    }
    
    func fireLaser() -> Void {
        var shot = LaserShot(parentNode: shipSprite.parent!, pos: CGPointMake(shipSprite.position.x, shipSprite.position.y+shipSprite.size.height))
        shot.Shoot()
        playSound()
        removeShotsOutsideScreen()
    }
    
    var avPlayer = AVAudioPlayer()
    
    func playSound(){
        var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Laser1", ofType: "caf")!)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        avPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        avPlayer.prepareToPlay()
        avPlayer.play()
        avPlayer.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
    }
    
    func removeShotsOutsideScreen() {
        shipSprite.parent?.enumerateChildNodesWithName("*") {
            node,stop in
            if let name = node.name {
                if (name == "lasershot") {
                    var finalPos = node.parent?.frame.height

                    if (node.position.y >= finalPos) {
                        node.removeFromParent()
                    }
                }
            }
        }
        
    }
}
