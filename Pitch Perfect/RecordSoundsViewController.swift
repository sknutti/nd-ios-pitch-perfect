//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Scott Knutti on 10/10/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate  {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var helpMessage: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
        pauseButton.isHidden = true
        recordButton.isEnabled = true
        helpMessage.isHidden = false
        
        if let image = UIImage(named: "Pause") {
            pauseButton.setImage(image, for: UIControlState())
        }
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        recordButton.isEnabled = false
        helpMessage.isHidden = true
        recordingInProgress.isHidden = false
        stopButton.isHidden = false
        pauseButton.isHidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            showAlert("Recording was not successful")
            recordButton.isEnabled = true
            helpMessage.isHidden = false
            stopButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseRecording(_ sender: UIButton) {
        if (audioRecorder.isRecording) {
            audioRecorder.pause()
            if let image = UIImage(named: "Resume") {
                pauseButton.setImage(image, for: UIControlState())
            }
        } else {
            audioRecorder.record()
            if let image = UIImage(named: "Pause") {
                pauseButton.setImage(image, for: UIControlState())
            }
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordingInProgress.isHidden = true
        helpMessage.isHidden = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

