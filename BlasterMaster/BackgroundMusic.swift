//
//  BackgroundMusic.swift
//  BlasterMaster
//
//  Created by Lars Bergqvist on 2015-09-14.
//  Copyright (c) 2015 Lars Bergqvist. All rights reserved.
//

import Foundation
import AVFoundation

class BackGroundMusic : NSObject, AVAudioPlayerDelegate {
    var avPlayer = AVAudioPlayer()
    
    func playSound(){
        var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ArturiaMood1", ofType: "mp3")!)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        avPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        avPlayer.numberOfLoops = -1
        avPlayer.volume = 0.1
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    func StopSound() {
        avPlayer.stop()
    }
    

}