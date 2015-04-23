//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Felix Christmann-Jacoby on 16.04.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//


import UIKit
import AVFoundation

var audioRecorder: AVAudioRecorder!
var recordedAudio: RecordedAudio!

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var nowRecordingLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    

    override func viewWillAppear(animated: Bool) {
        //this function will be called just right before the view appears
        //update elements of the View
        
        startRecordingButton.enabled = true
        stopRecordingButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        nowRecordingLabel.text = "Tap to Record"
    }
    
    @IBAction func startRecording(sender: AnyObject) {
        //triggered by startRecordingButton
        //show and hide elements of the View & set label texts
        //setup filename and path
        //  get path of .DocumentDirectory
        //  get current date and time and format to a String & add ".wav" to name
        //  print file path to console
        //setup audio session
        //initialize audio recorder
        //give delegate to audio recorder
        //setup and prepare audio recorder
        //start recording
        
        startRecordingButton.enabled = false
        stopRecordingButton.hidden = false
        nowRecordingLabel.text = "recording in progress"
        pauseButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(sender: AnyObject) {
        //triggered by stopRecordingButton
        //update elements of the View
        //stop audio recorder and audio session
        
        startRecordingButton.enabled = true
        stopRecordingButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func pauseRecording(sender: AnyObject) {
        //triggered by pauseButton
        //update elements of the View
        //pause audio recorder
        
        pauseButton.hidden = true
        resumeButton.hidden = false
        nowRecordingLabel.text = "recording paused"
        
        audioRecorder.pause()
    }

    @IBAction func resumeRecording(sender: AnyObject) {
        //triggered by resumeButton
        //update elements of the View & set label text
        //resume audio recorder
        
        pauseButton.hidden = false
        resumeButton.hidden = true
        nowRecordingLabel.text = "recording in progress"
        
        audioRecorder.record()
    }
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            //this function is called before segue "stopRecording" is performed
            //calling the segue destination and save the sender class in receivedAudio
            
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            playSoundVC.receivedAudio = data
        }
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //triggered by audio recorder did finish recording
        if(flag) {
            //audio recorded successfully -> true
            //initialize instance of RecordedAudio
            //perform segue - identifier: "stopRecording", sender: recordedAudio
            
            recordedAudio = RecordedAudio(url: recorder.url, titleArg: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            //audio recorded successfully -> false
            //print error
            //update elements of the View
            
            println("Recording was not successful")
            
            startRecordingButton.enabled = true
            stopRecordingButton.hidden = true
        }
    }
}

