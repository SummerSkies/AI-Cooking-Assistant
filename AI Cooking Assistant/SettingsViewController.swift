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
    @IBOutlet weak var voiceControlInfoButton: UIButton!
    
    @IBOutlet weak var textToSpeechSwitch: UISwitch!
    @IBOutlet weak var textToSpeechInfoButton: UIButton!
    
    @IBOutlet weak var voiceSpeedSlider: UISlider!
    @IBOutlet weak var voiceSpeedInfoButton: UIButton!
    
    @IBOutlet weak var chefSelectionMenu: UIMenu!
    @IBOutlet weak var chefSelectionInfoButton: UIButton!
    
    @IBOutlet weak var speechBubbleLabel: UILabel!
    @IBOutlet weak var speechBubbleImageView: UIImageView!
    @IBOutlet weak var selectedChefView: UIView!
    
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
        
        print("Granted: \(audioSession.recordPermission == .granted) \nDenied: \(audioSession.recordPermission == .denied) \nUndetermined: \(audioSession.recordPermission == .undetermined)")
        if SFSpeechRecognizer.authorizationStatus() == .authorized {
            userDefaults.set(voiceControlSwitch.isOn, forKey: "IsVoiceControlEnabled")
        } else {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                DispatchQueue.main.async {
                    print("Authorization status: \(authStatus.rawValue)")
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
        switch SFSpeechRecognizer.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            voiceControlSwitch.isOn = false
            userDefaults.setValue(false, forKey: "IsVoiceControlEnabled")
        case .authorized:
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
}
