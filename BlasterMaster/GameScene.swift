//
//  GameScene.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-13.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox
import AVFoundation

typealias EnemyHitHandler = ( (SKNode,SKNode) -> Void)
typealias PlayerHitHandler = ((SKNode,SKNode) -> Void)

let laserShotBitMask:UInt32 = 0x01
let enemyBitMask:UInt32 = 0x02
let playerBitMask:UInt32 = 0x04
let enemyShotBitMask:UInt32 = 0x08

class GameScene: SKScene {
    
    let spaceShip:SpaceShip = SpaceShip(initialYPos: 100.0)
    let motionManager: CMMotionManager = CMMotionManager()
    var enemySpawner:EnemySpawner?
    var collisionDetector : CollisionDetector?
    var bgHeight:CGFloat = 0.0
    let bgMusic = BackGroundMusic()
    var bgGfx:BackgroundGfx?
    let explosionPlayer = ExplosionPlayer()


    override func didMoveToView(view: SKView) {

        bgGfx = BackgroundGfx(parent:self)

        
        self.anchorPoint = CGPointMake(0, 0)
        
        scoreLabel.fontSize = 25;
        scoreLabel.position = CGPointMake(100,0)
        self.addChild(scoreLabel)
        livesLabel.fontSize = 25;
        livesLabel.position = CGPointMake(self.frame.width-200,0)
        self.addChild(livesLabel)

        spaceShip.addShipToParent(self,pos: CGPointMake( CGRectGetMidX(self.frame), spaceShip.initialYPos))
        
        motionManager.startAccelerometerUpdates()
        
        enemySpawner = EnemySpawner(parent: self)
        enemySpawner?.spawnNewEnemy()
        
        // world
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.name = "edge"
        collisionDetector = CollisionDetector(g:enemyHit, e:playerHit)
        self.physicsWorld.contactDelegate = collisionDetector
        
        updateScoreLabel()
        updateLivesLabel()
        
        bgMusic.playSound()

    }
    
    let explosion = ExplosionAtlas()
    
    func enemyHit(enemyNode:SKNode,laserNode:SKNode) {
        laserNode.removeFromParent()
        enemyNode.physicsBody?.dynamic = false
        enemyNode.physicsBody?.categoryBitMask = 0
        enemyNode.name = ""
        score++
        updateScoreLabel()
        
        explosionPlayer.playSound()
        
        let expl = SKAction.animateWithTextures(explosion.expl_01_(), timePerFrame: 0.05)
        
        var enemySprite = enemyNode as! SKSpriteNode
        enemySprite.runAction(expl, completion: { () -> Void in
            enemyNode.removeFromParent()
            
        })
    }
    
    func playerHit(player:SKNode,hitObject:SKNode) {
        lives--
        updateLivesLabel()
        hitObject.removeFromParent()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if (lives < 1) {
            endGame()
        }
    }
    
    func endGame() {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 3.0)
        
        let scene = GameOverScene(size: self.scene!.size)
        scene.score = score
        scene.scaleMode = SKSceneScaleMode.AspectFit
        scene.backgroundColor = UIColor.blackColor()
        
        self.scene?.view?.presentScene(scene, transition: transition)
        bgMusic.StopSound()
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)

            spaceShip.firePressed = true

        }
    }
    
   
    var waitCounter = 0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        processUserMotionForUpdate(currentTime)
        spaceShip.updateActions()
        spawnNewEnemy()
        if (waitCounter > 100)
        {
            enemySpawner?.removeEnemiesOutsideScreen()
            waitCounter = 0
        }
        waitCounter++
        bgGfx?.scrollBackground()

    }
    
    var count = 0
    var timeBetweenSpawns=200
    func spawnNewEnemy() {
        if (count > timeBetweenSpawns)
        {
            enemySpawner?.spawnNewEnemy()
            count=0
            if (timeBetweenSpawns > 20) {
                timeBetweenSpawns -= 10
            }
            
        }
        count++
    }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        if let data = motionManager.accelerometerData {
            
            if (data.acceleration.x > 0.2) {
                spaceShip.horizontalAction = .MoveRight
                spaceShip.horizontalSpeed = fabs(data.acceleration.x)
                
            }
            else if (data.acceleration.x < -0.2) {
                spaceShip.horizontalAction = .MoveLeft
                spaceShip.horizontalSpeed = fabs(data.acceleration.x)
                
            }
            else {
                spaceShip.horizontalAction = .None
                spaceShip.horizontalSpeed = 0.0
            }
            
            if (data.acceleration.y > 0.2) {
                spaceShip.verticalAction = .MoveUp
                spaceShip.verticalSpeed = fabs(data.acceleration.y)
                
            }
            else if (data.acceleration.y < -0.2) {
                spaceShip.verticalAction = .MoveDown
                spaceShip.verticalSpeed = fabs(data.acceleration.y)
                
            }
            else {
                spaceShip.verticalAction = .None
                spaceShip.verticalSpeed = 0.0
            }

        }
    }
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    let playerYPos = 100.0
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    var lives = 5
    let livesLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    func updateLivesLabel() {
        livesLabel.text = "Lives: \(lives)"
    }



}
