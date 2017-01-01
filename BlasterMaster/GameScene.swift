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

    override func didMove(to view: SKView) {

        bgGfx = BackgroundGfx(parent:self)
        bgGfx?.setupBackgroup()

        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        setupPhysicsWorld()
        
        setupScorebar()
        
        spaceShip.addShipToParent(self,pos: CGPoint( x: self.frame.midX, y: spaceShip.initialYPos))
        
        enemySpawner = EnemySpawner(parent: self)
        
        updateScoreLabel()
        
        updateEnergyMeter()
        
        bgMusic.playSound()

        motionManager.startAccelerometerUpdates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        spaceShip.firePressed = true
            
    }
    
    
    var waitCounter = 0
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        processUserMotionForUpdate(currentTime)
        
        spaceShip.updateActions()
        
        spawnNewEnemy()
        
        if (waitCounter > 100)
        {
            enemySpawner?.removeEnemiesOutsideScreen()
            waitCounter = 0
        }
        waitCounter += 1
        
        bgGfx?.scrollBackground()
        
    }

    
    func setupPhysicsWorld()
    {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.name = "edge"
        collisionDetector = CollisionDetector(g:enemyHit, e:playerHit)
        self.physicsWorld.contactDelegate = collisionDetector
    }
    
    let explosion = ExplosionAtlas()
    
    func enemyHit(_ enemyNode:SKNode,laserNode:SKNode) {
        laserNode.removeFromParent()
        enemyNode.physicsBody?.isDynamic = false
        enemyNode.physicsBody?.categoryBitMask = 0
        enemyNode.name = ""
        score += 1
        updateScoreLabel()
        
        explosionPlayer.playSound()
        
        let expl = SKAction.animate(with: explosion.expl_01_(), timePerFrame: 0.05)
        let enemySprite = enemyNode as! SKSpriteNode
        enemySprite.run(expl, completion: { () -> Void in
            enemyNode.removeFromParent()
            
        })
    }
    
    let hitAtlas = HitAtlas()
    
    func playerHit(_ player:SKNode,hitObject:SKNode,contactPoint:CGPoint) {
        hitObject.name = ""
        energy -= 1
        updateEnergyMeter()
        hitObject.removeFromParent()
        
        // Vibrate device
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // Animate a hit on the player ship
        let pointInSprite = player.convert(contactPoint, from: self)
        let hit = SKSpriteNode(texture: hitAtlas.laserBlue08())
        hit.position = pointInSprite
        hit.zPosition = 10
        player.addChild(hit)
        let expl = SKAction.animate(with: hitAtlas.laserBlue(), timePerFrame: 0.05)
        hit.run(expl, completion: { () -> Void in
            hit.removeFromParent()
        })
        
        if (energy < 1) {
            endGame()
        }


    }
    
    func endGame() {
        let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 3.0)
        
        let scene = GameOverScene(size: self.scene!.size)
        scene.score = score
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = UIColor.black
        
        self.scene?.view?.presentScene(scene, transition: transition)
        bgMusic.StopSound()
    }

    
    var timeBetweenSpawns=200
    var count = 0
    func spawnNewEnemy() {
        if (count > timeBetweenSpawns)
        {
            enemySpawner?.spawnNewEnemy(spaceShip.GetCurrentPosition())
            count=0
            if (timeBetweenSpawns > 20) {
                timeBetweenSpawns -= 10
            }
            
        }
        count += 1
    }
    
    func processUserMotionForUpdate(_ currentTime: CFTimeInterval) {
        if let data = motionManager.accelerometerData {
            
            if (data.acceleration.x > 0.2) {
                spaceShip.horizontalAction = .moveRight
                spaceShip.horizontalSpeed = fabs(data.acceleration.x)
                
            }
            else if (data.acceleration.x < -0.2) {
                spaceShip.horizontalAction = .moveLeft
                spaceShip.horizontalSpeed = fabs(data.acceleration.x)
                
            }
            else {
                spaceShip.horizontalAction = .none
                spaceShip.horizontalSpeed = 0.0
            }
            
            if (data.acceleration.y > 0.2) {
                spaceShip.verticalAction = .moveUp
                spaceShip.verticalSpeed = fabs(data.acceleration.y)
                
            }
            else if (data.acceleration.y < -0.2) {
                spaceShip.verticalAction = .moveDown
                spaceShip.verticalSpeed = fabs(data.acceleration.y)
                
            }
            else {
                spaceShip.verticalAction = .none
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
            for _ in 0...energy-1 {
                energyBar += "❤️"
            }
        }
        energyMeter.text = energyBar
    }

    func setupScorebar()
    {
        scoreLabel.fontSize = 25;
        scoreLabel.position = CGPoint(x: 100,y: 0)
        self.addChild(scoreLabel)
        energyLabel.fontSize = 25;
        energyLabel.position = CGPoint(x: self.frame.width-200,y: 0)
        self.addChild(energyLabel)
        energyMeter.fontSize = 25;
        energyMeter.position = CGPoint(x: self.frame.width-250,y: 0)
        self.addChild(energyMeter)
    }



}
