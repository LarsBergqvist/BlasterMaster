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

    class func SpriteName() -> String {
        return "player"
    }
    
    enum HorizontalAction {
        case none
        case moveLeft
        case moveRight
    }
    
    enum VerticalAction {
        case none
        case moveUp
        case moveDown
    }
    
    var firePressed:Bool = false
    var horizontalAction:HorizontalAction = HorizontalAction.none
    var verticalAction:VerticalAction = VerticalAction.none
    var horizontalSpeed = Double(0.0)
    var verticalSpeed = Double(0.0)
    let speedFactor = 30.0
    
    let shipSprite:SKSpriteNode = SKSpriteNode(imageNamed: "playerShip1_blue")

    func GetCurrentPosition() -> CGPoint {        
        return shipSprite.position
    }
    
    var initialYPos:CGFloat = 0.0
    
    init (initialYPos:CGFloat) {
        self.initialYPos = initialYPos
    }
    
    func addShipToParent(_ parent:SKNode, pos:CGPoint) -> Void {
        shipSprite.xScale = 1
        shipSprite.yScale = 1
        shipSprite.position = pos
        
        let spTexture = SKTexture(imageNamed: "playerShip1_blue")

        shipSprite.physicsBody = SKPhysicsBody(texture: spTexture, size: shipSprite.size)
        shipSprite.physicsBody?.isDynamic = true
        shipSprite.physicsBody?.allowsRotation = false
        shipSprite.name = SpaceShip.SpriteName()

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
            fireWaitCount += 1
        }
        
        if (horizontalAction == .moveLeft) {
            if (shipSprite.position.x > 0 ) {
                shipSprite.position.x -= CGFloat(speedFactor)*CGFloat(horizontalSpeed)
            }
        }
        else if (horizontalAction == .moveRight) {
            if (shipSprite.position.x < (shipSprite.parent?.frame.width)! ) {
                shipSprite.position.x += CGFloat(speedFactor)*CGFloat(horizontalSpeed)
            }
        }
        
        if (verticalAction == .moveDown) {
            let newPos = shipSprite.position.y - CGFloat(speedFactor)*CGFloat(verticalSpeed)
            if (newPos >= initialYPos ) {
                shipSprite.position.y = newPos
            }
        }
        else if (verticalAction == .moveUp) {
            let newPos = shipSprite.position.y + CGFloat(speedFactor)*CGFloat(verticalSpeed)
            if (newPos < (shipSprite.parent?.frame.height)!/2 ) {
                shipSprite.position.y = newPos
            }
        }

    }
    
    func fireLaser() -> Void {
        let shot = LaserShot(parentNode: shipSprite.parent!, pos: CGPoint(x: shipSprite.position.x, y: shipSprite.position.y+shipSprite.size.height))
        shot.Shoot()
        playSound()
        removeShotsOutsideScreen()
    }
    
    var avPlayer = AVAudioPlayer()
    
    func playSound(){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Laser1", ofType: "caf")!)
        
        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer.volume = 0.5
            avPlayer.prepareToPlay()
            avPlayer.play()
            avPlayer.delegate = self
        }
        catch _ {
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
    
    func removeShotsOutsideScreen() {
        shipSprite.parent?.enumerateChildNodes(withName: "*") {
            node,stop in
            if let name = node.name {
                if (name == LaserShot.SpriteName()) {
                    let finalPos = node.parent?.frame.height

                    if (node.position.y >= finalPos!) {
                        node.removeFromParent()
                    }
                }
            }
        }
        
    }
}
