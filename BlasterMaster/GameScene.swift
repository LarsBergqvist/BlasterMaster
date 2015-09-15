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


    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        setupBackgroup(self)

        
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
        
        playSound()
        
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
    
    var avPlayer = AVAudioPlayer()
    
    func playSound(){
        
        var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Expl1", ofType: "caf")!)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        avPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        avPlayer.volume = 1.0
        avPlayer.prepareToPlay()
        avPlayer.play()
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        spaceShip.moveLeft = false
//        spaceShip.moveRight = false
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
//        spaceShip.shipSprite.position.y = CGFloat(playerYPos)
        scrollBackground()

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

    var scrollPos = 0
    func scrollBackground() {
        
        scrollPos++
        var restore = false
        if (CGFloat(scrollPos) > bgHeight) {
            scrollPos=0
            restore=true
        }
        
        self.enumerateChildNodesWithName("*") {
            node,stop in
            if let name = node.name {
                if (name == "background") {
                    if (restore) {
                        node.position.y += self.bgHeight
                    }
                    else {
                        node.position.y--
                    }
                }
            }
        }
        
    }
    
    func setupBackgroup(parent:SKNode) {
        for j in 0...3 {
            
            for i in 0...1 {
                var bg = SKSpriteNode(imageNamed: "blue")
                bg.xScale = 2.0
                bg.yScale = 2.0
                bg.anchorPoint = CGPointZero
                bg.position = CGPointMake(CGFloat(i) * bg.size.width, CGFloat(j)*bg.size.height)
                bg.name = "background"
                bg.zPosition = -10
                bgHeight = bg.size.height
                parent.addChild(bg)
            }
        }
    }


}
