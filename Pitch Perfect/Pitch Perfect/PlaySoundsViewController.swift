//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Felix Christmann-Jacoby on 16.04.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var receivedAudio: RecordedAudio!
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        //function called when view did load
        //initialize audio player with receivedAudio
        //initialize AVAudioEngine with receivedAudio
        
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    
    @IBAction func playSoundSlow(sender: AnyObject) {
        //play recorded sound slow
        //stop & reset audio engine
        //stop audio player
        //change play rate of audio player
        //start play
        
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func playSoundFast(sender: AnyObject) {
        //play recorded audio fast
        //stop & reset audio engine
        //stop audio player
        //change play rate of audio player
        //start play
        
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        //call playAudioWithVariablePitch with pitch 1000 - like chipmunk
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        //call playAudioWithVariablePitch with pitch -1000 - like darthvader
        playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        //play recorded audio with variable pitch
        //stop & reset audio engine
        //stop audio player
        //initialize audio player node & attach to audio engine
        //Initialize unit time pitch effect, change pitch to func arg pitch & attach to audio engine
        //connect audio player node to unit time pitch effect
        //connect unit time pitch effect the output node of audio engine
        //schedule audio player node with audioFile
        //start audio engine
        //start play audio player node
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playEchoSound(sender: AnyObject) {
        //call playAudioWithEffect with delay effect
        playAudioWithEffect(AVAudioUnitDelay())
    }
    
    @IBAction func playReverbSound(sender: AnyObject) {
        //call playAudioWithEffect with reverb effect (wetDryMix = 50)
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 50
        playAudioWithEffect(reverbEffect)
    }
    
    func playAudioWithEffect(effect: AVAudioUnitEffect){
        //play recorded audio with effect (received in argument)
        //stop & reset audio engine
        //stop audio player
        //initialize audio player node & attach to audio engine
        //attach effect to audio engine
        //connect audio player node to effect
        //connect effect the output node of audio engine
        //schedule audio player node with audioFile
        //start audio engine
        //start play audio player node

        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    @IBAction func stopAudio(sender: AnyObject) {
        //stop audio player & audio engine
        audioPlayer.stop()
        audioEngine.stop()
    }

}
