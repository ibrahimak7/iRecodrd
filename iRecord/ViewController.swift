//
//  ViewController.swift
//  iRecord
//
//  Created by Ibrahim on 06/01/2019.
//  Copyright © 2019 Ibrahim. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    var recordButton: UIButton!
    var recordSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordSession = AVAudioSession.sharedInstance()
        
        do {
            try recordSession.setCategory(.playAndRecord, mode: .default)
            try recordSession.setActive(true)
            recordSession.requestRecordPermission { (response) in
                if response {
                    self.loadRecordingUI()
                    print("Congrates you do have permission now.")
                }else{
                    print("You don't have permission")
                }
            }
        }catch{
            
        }
        
    }
    func loadRecordingUI() {
        print("hi")
        recordButton = UIButton(type: .system)
        recordButton = UIButton(frame: CGRect(x: 200, y: 100, width: 128, height: 30))
        recordButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.backgroundColor = UIColor.brown
        recordButton.addTarget(self, action: #selector(recordNow), for: .touchUpInside)
        self.view.addSubview(recordButton)
    }
    @objc func recordNow(){
        print("Recording")
    }

}

