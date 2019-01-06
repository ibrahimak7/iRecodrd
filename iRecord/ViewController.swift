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
                    print("Congrates you do have permission now.")
                }else{
                    print("You don't have permission")
                }
            }
        }catch{
            
        }
        
    }


}

