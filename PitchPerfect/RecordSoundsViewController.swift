//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Nate Powers on 10/8/17.
//  Copyright © 2017 Nate Powers. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // woo!
    var audioRecorder : AVAudioRecorder!
    
    // outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stopRecordingButton.isEnabled = false // disable by default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // note: in iOS a "will" method is always called before a "did" method
    }

    // start recording audio
    @IBAction func recordAudio(_ sender: AnyObject) {
        setViewsWhenRecording(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

   
    // stops recording
    @IBAction func stopRecording(_ sender: Any) {
        setViewsWhenRecording(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // sets the views and text based on recording state
    func setViewsWhenRecording(recording : Bool ) {
        if ( recording ) {
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        } else {
            recordingLabel.text = "Tap to Record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if ( flag ) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording failed")

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController // forced upcast
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

