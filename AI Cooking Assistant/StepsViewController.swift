//
//  StepsViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/6/23.
//

import UIKit

class StepsViewController: UIViewController {

    @IBOutlet weak var loadingStack: UIStackView!
    
    @IBOutlet weak var ingredientListStack: UIStackView!
    @IBOutlet weak var ingredientsTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsSpeechBubbleLabel: UILabel!
    @IBOutlet weak var ingredientsSpeechBubbleImageView: UIImageView!
    @IBOutlet weak var ingredientsChefView: UIView!
    
    @IBOutlet weak var stepNumberStack: UIStackView!
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet weak var voiceSettingsButton: UIBarButtonItem!
    
    @IBOutlet weak var loadingChefView: UIView!
    
    var indexBeingDisplayed: Int = 0
    let shared = ResponseObject.shared
    
    var speechSynthesizer: SpeechSynthesizer?
    let voiceRecognizer = VoiceRecognizer()
    
    let userDefaults = UserDefaults.standard
    
    var animationController: AnimationController?
    var imageArray: [UIImage] = [UIImage(named: "Red"), UIImage(named: "Blue"), UIImage(named: "Green"), UIImage(named: "Cactus"), UIImage(named: "Purple")].compactMap { $0 }
    
    var speechActivated: Bool {
        userDefaults.bool(forKey: "IsSpeechEnabled")
    }
    var voiceActivated: Bool {
        userDefaults.bool(forKey: "IsVoiceControlEnabled")
    }
    
    var formView: FormViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: NotificationManager.didReceiveNetworkResponse, object: nil)
        instructionsLabel.lineBreakMode = .byWordWrapping // or .byCharWrapping
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ingredientListStack.isHidden = true
        ingredientsSpeechBubbleLabel.isHidden = true
        stepNumberStack.isHidden = true
        
        loadingStack.isHidden = false
        
        voiceSettingsButton.isHidden = true
        
        voiceRecognizer.stepsController = self
        //voiceRecognizer.startListening()
        
        speechSynthesizer = SpeechSynthesizer(stepsController: self)
        
        if let peachyFolderURL = Bundle.main.url(forResource: "Peachy-Talk1x", withExtension: "gif"),
           let talkingGifData = try? Data(contentsOf: peachyFolderURL),
           let gifImage = UIImage.gif(data: talkingGifData) {
            imageArray.append(gifImage)
        } else {
            fatalError("Failed to load gif")
        }

        animationController = AnimationController(imageView: animatedImage)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: "IsVoiceControlEnabled") {
            voiceRecognizer.startListening()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationManager.didReceiveNetworkResponse, object: nil)
    }
    
    @objc func updateUI() {
        guard shared.response.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "There was a problem retrieving the data", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel) {_ in 
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
            return
        }
        
        
        
        if indexBeingDisplayed == 0 {
            loadingStack.isHidden = true
            
            voiceSettingsButton.isHidden = true
            ingredientListStack.isHidden = false
            ingredientsSpeechBubbleLabel.isHidden = false
            stepNumberStack.isHidden = true
            ingredientsTitleLabel.text = "Ingredients"
            ingredientsLabel.text = shared.response[indexBeingDisplayed]
            processSpeech()
            animationController?.setRandomImage()
        } else {
            voiceSettingsButton.isHidden = false
            ingredientListStack.isHidden = true
            ingredientsSpeechBubbleLabel.isHidden = true
            stepNumberStack.isHidden = false
            if let firstCharacter = shared.response[indexBeingDisplayed].first {
                // Check if the second character is also a number
                if shared.response[indexBeingDisplayed].count > 1,
                   let secondCharacter = shared.response[indexBeingDisplayed].dropFirst().first,
                   CharacterSet.decimalDigits.contains(secondCharacter.unicodeScalars.first!) {
                    
                    // Append the second character to the first one
                    let combinedString = "Step #\(firstCharacter)\(secondCharacter)"
                    stepNumberLabel.text = combinedString
                } else {
                    // Only the first character is a number
                    stepNumberLabel.text = "Step #\(firstCharacter)"
                }
            }
            instructionsLabel.text = shared.response[indexBeingDisplayed]
            
            instructionsLabel.sizeToFit()
            processSpeech()
            
        }
        
        if indexBeingDisplayed == shared.response.count - 1 {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
    }
    
    @IBAction func nextOrStartButtonTapped(_ sender: UIButton) {
        performNext()
    }
    
    func performNext() {
        if indexBeingDisplayed != shared.response.count - 1 {
            indexBeingDisplayed += 1
            updateUI()
        }
        
        if !speechActivated {
            animationController?.setRandomImage()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        performPrevious()
    }
    
    func performPrevious() {
        if indexBeingDisplayed != 0 {
            indexBeingDisplayed -= 1
            updateUI()
            
        }
        
        if !speechActivated {
            animationController?.setRandomImage()
        }
    }
    
    func processSpeech() {
        endSpeech()
        if indexBeingDisplayed > 0 {
            beginSpeech()
        }
    }
    
    func beginSpeech() {
        guard speechActivated && indexBeingDisplayed > 0 else {return}
        animationController?.setLastImage()
        
        let firstCharacter = shared.response[indexBeingDisplayed].first
        if let firstChar = firstCharacter, CharacterSet.decimalDigits.contains(firstChar.unicodeScalars.first!) {
            // The first character is a digit
            stepNumberLabel.isHidden = indexBeingDisplayed == 0 ? true : false
            speechSynthesizer?.beginSpeech("Step \(shared.response[indexBeingDisplayed])")
        } else {
            // The first character is not a digit
            stepNumberLabel.isHidden = true
            speechSynthesizer?.beginSpeech("\(shared.response[indexBeingDisplayed])")
        }
        
    }
    
    func endSpeech() {
        speechSynthesizer!.stopSpeech()
    }
    
    func doneTalking() {
        animationController?.setRandomImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        endSpeech()
        voiceRecognizer.stopListening()
        indexBeingDisplayed = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StepsToSettings" {
            let destination = segue.destination as! SettingsViewController
            destination.currentIndex = indexBeingDisplayed
            destination.stepsViewController = self
        }
    }
    
}
