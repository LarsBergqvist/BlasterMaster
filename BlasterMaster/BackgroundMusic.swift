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
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ArturiaMood1", ofType: "mp3")!)
        
        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer.numberOfLoops = -1
            avPlayer.volume = 0.1
            avPlayer.prepareToPlay()
            avPlayer.play()
        }
        catch _ {
        }
    }
    
    func StopSound() {
        avPlayer.stop()
    }
    

}
