//
//  SpeechSynthesizer.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/12/23.
//

import Foundation
import AVKit
import AVFoundation

class SpeechSynthesizer {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("An error occurred setting up audio session: \(error)")
        }
    }
    
    func beginSpeech(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = UserDefaults.standard.float(forKey: "SpeechSpeed")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}

