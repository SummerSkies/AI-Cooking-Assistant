//
//  SettingsViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/14/23.
//

import UIKit
import Foundation
import AVFAudio
import Speech

class SettingsViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var voiceControlSwitch: UISwitch!
    @IBOutlet weak var textToSpeechSwitch: UISwitch!
    @IBOutlet weak var voiceSpeedSlider: UISlider!
    
    var stepsViewController : StepsViewController?
    var currentIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMicrophonePermissionAndUpdateSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isVoiceControlEnabled = userDefaults.object(forKey: "IsVoiceControlEnabled") as? Bool {
            if isVoiceControlEnabled {
                voiceControlSwitch.isOn = true
            }
            else {
                voiceControlSwitch.isOn = false
            }
        }
        if let isSpeechEnabled = userDefaults.object(forKey: "IsSpeechEnabled") as? Bool {
            if isSpeechEnabled {
                textToSpeechSwitch.isOn = true
            }
            else {
                textToSpeechSwitch.isOn = false
            }
        }
        if let speechSpeed = userDefaults.object(forKey: "SpeechSpeed") as? Float {
            voiceSpeedSlider.value = speechSpeed
        }
    }
    
    @IBAction func voiceControlSwitchChanged(_ sender: Any) {
        let audioSession = AVAudioSession.sharedInstance()
        
        if audioSession.recordPermission == .granted {
            userDefaults.set(voiceControlSwitch.isOn, forKey: "IsVoiceControlEnabled")
        } else {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        print("Speech recognition authorization granted.")
                    } else if authStatus == .denied {
                        let alert = UIAlertController(
                            title: "Speech Recognition Not Enabled",
                            message: "Please enable speech recognition in the app settings to use this feature.",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                            self.checkMicrophonePermissionAndUpdateSwitch()
                        })
                        
                        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL)
                            }
                        })
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    
    @IBAction func textToSpeechSwitchChanged(sender: UISwitch) {
        userDefaults.set(textToSpeechSwitch.isOn, forKey: "IsSpeechEnabled")
    }
    
    @IBAction func speechSpeedSliderChanged(_ sender: Any) {
        userDefaults.set(voiceSpeedSlider.value, forKey: "SpeechSpeed")
    }
    
    func checkMicrophonePermissionAndUpdateSwitch() {
        let audioSession = AVAudioSession.sharedInstance()
        
        switch audioSession.recordPermission {
        case .denied, .undetermined:
            voiceControlSwitch.isOn = false
            userDefaults.setValue(false, forKey: "IsVoiceControlEnabled")
        case .granted:
            return
        @unknown default:
            fatalError("AVAudioSession recordPermission has unknown value.")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let stepsViewController = stepsViewController, let currentIndex = currentIndex {
            stepsViewController.indexBeingDisplayed = currentIndex
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
