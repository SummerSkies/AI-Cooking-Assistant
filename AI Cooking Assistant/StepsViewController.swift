//
//  StepsViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/6/23.
//

import UIKit

class StepsViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var ingredientListStack: UIStackView!
    @IBOutlet weak var ingredientsTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var stepNumberStack: UIStackView!
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var voiceControlStack: UIStackView!
    
    var indexBeingDisplayed: Int = 0
    let shared = ResponseObject.shared
    let speechSynthesizer = SpeechSynthesizer()
    let voiceRecognizer = VoiceRecognizer()
    let userDefaults = UserDefaults.standard
    
    var speechActivated: Bool {
        userDefaults.bool(forKey: "IsSpeechEnabled")
    }
    var voiceActivated: Bool {
        userDefaults.bool(forKey: "IsVoiceControlEnabled")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: NotificationManager.didReceiveNetworkResponse, object: nil)
        instructionsLabel.lineBreakMode = .byWordWrapping // or .byCharWrapping
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ingredientListStack.isHidden = true
        stepNumberStack.isHidden = true
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        voiceControlStack.isHidden = true
        
        voiceRecognizer.stepsController = self
        //voiceRecognizer.startListening()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        processSpeech()
        if userDefaults.bool(forKey: "IsVoiceControlEnabled") {
            voiceRecognizer.startListening()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationManager.didReceiveNetworkResponse, object: nil)
    }
    
    @objc func updateUI() {
        if indexBeingDisplayed == 0 {
            activityIndicator.stopAnimating()
            activityLabel.isHidden = true
            
            voiceControlStack.isHidden = true
            ingredientListStack.isHidden = false
            stepNumberStack.isHidden = true
            ingredientsTitleLabel.text = "Ingredients"
            ingredientsLabel.text = shared.response[indexBeingDisplayed]
            
            //nextOrStartButtonTapped([]) //For testing ease; uncomment to press Start button immediately after load. nextOrStartButtonTapped's sender must be changed to Any.
        } else {
            voiceControlStack.isHidden = false
            ingredientListStack.isHidden = true
            stepNumberStack.isHidden = false
            stepNumberLabel.text = "Step #\(indexBeingDisplayed)"
            instructionsLabel.text = shared.response[indexBeingDisplayed]
            
            instructionsLabel.sizeToFit()
        }
    }
    
    @IBAction func nextOrStartButtonTapped(_ sender: UIButton) {
        performNext()
    }
    
    func performNext() {
        if indexBeingDisplayed != shared.response.count - 1 {
            indexBeingDisplayed += 1
            updateUI()
            processSpeech()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        performPrevious()
    }
    
    func performPrevious() {
        if indexBeingDisplayed != 0 {
            indexBeingDisplayed -= 1
            updateUI()
            processSpeech()
        }
    }
    
    func processSpeech() {
        endSpeech()
        beginSpeech()
    }
    
    func beginSpeech() {
        guard speechActivated && indexBeingDisplayed > 0 else {return}
        speechSynthesizer.beginSpeech(shared.response[indexBeingDisplayed])
    }
    func endSpeech() {
        speechSynthesizer.stopSpeech()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        endSpeech()
        voiceRecognizer.stopListening()
    }
    
}
