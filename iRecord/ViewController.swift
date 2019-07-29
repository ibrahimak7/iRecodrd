//
//  ViewController.swift
//  iRecord
//
//  Created by Ibrahim on 06/01/2019.
//  Copyright © 2019 Ibrahim. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    var recordSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioTimer: Timer!
    var paused: Bool = false
   
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            print(fileURLs)
//            // process files
//        } catch {
//            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//        }
        
        recordButton.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        recordSession = AVAudioSession.sharedInstance()
        
        do {
            try recordSession.setCategory(.playAndRecord, mode: .default)
            try recordSession.setActive(true)
            recordSession.requestRecordPermission { (response) in
                if response {
                    self.recordButton.isHidden = false
                    print("Congrates you do have permission now.")
                }else{
                    print("You don't have permission")
                }
            }
        }catch{
            
        }
        
    }
    func getRandom()->Int{
        return Int(arc4random_uniform(42))+Int(arc4random_uniform(50))
    }
    func startRecording(){
        let name = "New Recording \(getRandom()).m4a"
        let audioName = getDocumentDirectory().appendingPathComponent(name)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            audioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioMeter(timer:)), userInfo: nil, repeats: true)
            changeBtnImage(action: "pause")

        }catch{
            finishRecording(success: false)
        }
    
    }
//    @objc func runTimeCode(){
//        timeLabel.text = "\(Int(audioRecorder.currentTime))"
//    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            changeBtnImage(action: "audioBtn")
            audioTimer.invalidate()
        } else {
            print("Failed")
            // recording failed :(
        }
    }
    func getDocumentDirectory()->URL {
     let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    @IBAction func recordBtnTapped(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
//    func startTimer(){
//        audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: true)
//    }
    @IBAction func finishRecordButton(_ sender: Any) {
        finishRecording(success: true)
    }
    func changeBtnImage(action: String){
        recordButton.setImage(UIImage(named: action), for: .normal)
    }
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            timeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
}

