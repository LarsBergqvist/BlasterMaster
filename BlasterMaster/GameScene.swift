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

typealias EnemyHitHandler = ( (SKNode,SKNode) -> Void)
typealias PlayerHitHandler = ((SKNode,SKNode,CGPoint) -> Void)

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
        bgGfx?.setupBackgroup()

        self.anchorPoint = CGPointMake(0, 0)
        
        setupPhysicsWorld()
        
        setupScorebar()
        
        spaceShip.addShipToParent(self,pos: CGPointMake( CGRectGetMidX(self.frame), spaceShip.initialYPos))
        
        enemySpawner = EnemySpawner(parent: self)
        
        updateScoreLabel()
        
        updateEnergyMeter()
        
        bgMusic.playSound()

        motionManager.startAccelerometerUpdates()
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

    
    func setupPhysicsWorld()
    {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.name = "edge"
        collisionDetector = CollisionDetector(g:enemyHit, e:playerHit)
        self.physicsWorld.contactDelegate = collisionDetector
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
    
    let hitAtlas = HitAtlas()
    
    func playerHit(player:SKNode,hitObject:SKNode,contactPoint:CGPoint) {
        energy--
        updateEnergyMeter()
        hitObject.removeFromParent()
        
        // Vibrate device
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // Animate a hit on the player ship
        var pointInSprite = player.convertPoint(contactPoint, fromNode: self)
        var hit = SKSpriteNode(texture: hitAtlas.laserBlue08())
        hit.position = pointInSprite
        hit.zPosition = 10
        player.addChild(hit)
        let expl = SKAction.animateWithTextures(hitAtlas.laserBlue(), timePerFrame: 0.05)
        hit.runAction(expl, completion: { () -> Void in
            hit.removeFromParent()
        })
        
        if (energy < 1) {
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

    
    var timeBetweenSpawns=200
    var count = 0
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
    
    var energy = 5
    let energyLabel = SKLabelNode(fontNamed:"Lucida Grande")
    let energyMeter = SKLabelNode(fontNamed:"Lucida Grande")
    
    func updateEnergyMeter() {
        var energyBar = ""
        if (energy > 0)
        {
            for i in 0...energy-1 {
                energyBar += "❤️"
            }
        }
        energyMeter.text = energyBar
    }

    func setupScorebar()
    {
        scoreLabel.fontSize = 25;
        scoreLabel.position = CGPointMake(100,0)
        self.addChild(scoreLabel)
        energyLabel.fontSize = 25;
        energyLabel.position = CGPointMake(self.frame.width-200,0)
        self.addChild(energyLabel)
        energyMeter.fontSize = 25;
        energyMeter.position = CGPointMake(self.frame.width-250,0)
        self.addChild(energyMeter)
    }



}
