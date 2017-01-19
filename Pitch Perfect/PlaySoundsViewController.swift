//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Scott Knutti on 11/19/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        } catch let error as NSError {
            showAlert("\(error.localizedDescription)")
        }
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        do {
            try audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        } catch let error as NSError {
            showAlert("\(error.localizedDescription)")
        }
    }

    @IBAction func playSlowAudio(_ sender: UIButton) {
        playAudio(0.5)
    }

    @IBAction func playFastAudio(_ sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        stopAllAudio()
    }
    
    @IBAction func playEchoAudio(_ sender: UIButton) {
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = TimeInterval(0.3)
        audioEngine.attach(echoEffect)
        
        audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch let error as NSError {
            showAlert("\(error.localizedDescription)")
        }
        
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(_ sender: UIButton) {
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.cathedral)
        reverbEffect.wetDryMix = 50
        audioEngine.attach(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch let error as NSError {
            showAlert("\(error.localizedDescription)")
        }
        
        audioPlayerNode.play()
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio(_ playRate: Float) {
        stopAllAudio()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(_ pitch: Float) {
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch let error as NSError {
            showAlert("\(error.localizedDescription)")
        }
        
        audioPlayerNode.play()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
