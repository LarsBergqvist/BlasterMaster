//
//  GameViewController.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-13.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = StartScene(fileNamed: "StartScene") {
                // Configure the view.
                scene.size = CGSize(width: 640,height: 1136)
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                skView.ignoresSiblingOrder = true
                scene.scaleMode = SKSceneScaleMode.fill
                scene.backgroundColor = UIColor.black
                view.presentScene(scene)
            }            
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
