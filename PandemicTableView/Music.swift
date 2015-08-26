//
//  Music.swift
//  Pandemic_TableView
//
//  Created by Yakov on 8/14/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

import UIKit
import AVFoundation

extension ViewController {
    func playBackgroundMusic() {
        if isBackgroundMusicOff {
            return
        }
        
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("EvilPiece", ofType: "mp3")!)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        audioPlayer.numberOfLoops = -1  //play this sound in loop
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func stopBackgroundMusic() {
        if isBackgroundMusicOff {
            return
        }
        
        audioPlayer.stop()
    }
    
    func playSoundForStatusCell() {
        if isSystemMusicOff || isScrolling {
            return
        }
        
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sound design data readout electronic beeps_BLASTWAVEFX_06197", ofType: "mp3")!)
        
        var mySound = SystemSoundID()
        AudioServicesCreateSystemSoundID(sound, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }
    
    func playSoundForDialogCell() {
        if isSystemMusicOff || isScrolling {
            return
        }
        
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Electronic device beeps 02_SFXBible_ss05892", ofType: "mp3")!)
        
        var mySound = SystemSoundID()
        AudioServicesCreateSystemSoundID(sound, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }
    
    func playSoundWhenButtonIsPressed() {
        if isSystemMusicOff || isScrolling {
            return
        }
        
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sound design boom hit low and ominous 1", ofType: "mp3")!)
        
        var mySound = SystemSoundID()
        AudioServicesCreateSystemSoundID(sound, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }
    
    func playSoundWhenButtonIsAppear() {
        if isSystemMusicOff || isScrolling {
            return
        }
        
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Walkie talkie or two-way talk beep-1", ofType: "mp3")!)
        
        var mySound = SystemSoundID()
        AudioServicesCreateSystemSoundID(sound, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }
    
    func turnOnMusic() {
        isBackgroundMusicOff = false
        isSystemMusicOff = false
        
        playBackgroundMusic()
    }
    
}










