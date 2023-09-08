//
//  ViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/6/23.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var promptTextField: UITextField!
    @IBOutlet weak var cookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptTextField.delegate = self
        cookButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        promptTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func promptEditingDidEnd(_ sender: Any) {
        let alphabet = NSCharacterSet.letters
        if let prompt = promptTextField.text, prompt.rangeOfCharacter(from: alphabet) != nil {
            cookButton.isEnabled = true
        } else {
            cookButton.isEnabled = false
        }
    }
    
    @IBAction func cookButtonTapped(_ sender: UIButton) {
        let shared = ResponseObject.shared
        Task {
            shared.response.removeAll()
            let response = await OpenAIService.shared.sendMessage(messages: [
                Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
                Message(id: UUID().uuidString, role: .user, content: "Generate a recipe title and list of ingredients based on this request: \(promptTextField.text!)")
            ])
            
            let ingredientResponse = response?.choices[0].message.content
            if let firstResponse = ingredientResponse {
                shared.response.append(firstResponse)
                print("Ingredient response: \(ingredientResponse!)")
            }
            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
            
            let response2 = await OpenAIService.shared.sendMessage(messages: [
                Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
                Message(id: UUID().uuidString, role: .user, content: "Generate only steps for how to prepare this recipe in the format 1. 2. 3. etc. based on this list of ingredients: \(ingredientResponse!)")
            ])
            
            let stepsResponse = response2?.choices[0].message.content
            if let secondResponse = stepsResponse {
                ResponseObject.convertStepsToList(input: secondResponse, modify: &shared.response)
                print("steps response: \(secondResponse)")
            }
            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
        }
    }
}

