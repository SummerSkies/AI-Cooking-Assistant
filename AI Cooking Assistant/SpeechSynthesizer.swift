//
//  SpeechSynthesizer.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/12/23.
//

import Foundation
import AVKit

class SpeechSynthesizer {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func beginSpeech(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.56
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}
