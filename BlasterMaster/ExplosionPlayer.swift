//
//  ExplosionPlayer.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-15.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import AVFoundation

class ExplosionPlayer {
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
    
}