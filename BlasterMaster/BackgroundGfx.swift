//
//  BackgroundGfx.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-15.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import SpriteKit

class BackgroundGfx {
    
    var parent:SKScene?
    var bgHeight:CGFloat = 0
    
    init (parent:SKScene) {
        self.parent = parent
    }
    
    var scrollPos = 0
    func scrollBackground() {
        
        scrollPos++
        var restore = false
        if (CGFloat(scrollPos) > bgHeight) {
            scrollPos=0
            restore=true
        }
        
        parent?.enumerateChildNodesWithName("*") {
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
    
    func setupBackgroup() {
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
                parent?.addChild(bg)
            }
        }
    }
  
}