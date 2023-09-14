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
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice.speechVoices().filter({
            $0.language.contains("en")
        }).randomElement()!
        
        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}

