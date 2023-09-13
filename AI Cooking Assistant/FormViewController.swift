//
//  FormViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/12/23.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var promptTextField: UITextField!
    @IBOutlet weak var cookButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        promptTextField.delegate = self
        //cookButton.isEnabled = false
    }
    
    //For testing ease; taps Cook immediately after load
//    override func viewDidAppear(_ animated: Bool) {
//        cookButton.sendActions(for: .touchUpInside)
//    }

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
    let testObject1 = "Recipe Title: Gourmet Mushroom Swiss Burgers \nIngredients: \n- 1 lb ground beef \n- 4 burger buns \n- 4 slices of Swiss cheese \n- 1 cup sliced mushrooms (button or cremini) \n- 1 small onion, thinly sliced \n- 2 cloves garlic, minced \n- 2 tablespoons olive oil \n- Salt and pepper, to taste \n- Optional toppings: lettuce, tomato, caramelized onions, ketchup, mustard"
    let testObject2 = "1. In a large skillet, heat 1 tablespoon of olive oil over medium heat. \n2. Add the sliced onions and cook until they are caramelized, stirring occasionally. This should take about 10 minutes. \n3. In the same skillet, add the sliced mushrooms and minced garlic. Cook for another 5 minutes until the mushrooms are softened. \n4. Remove the onion and mushroom mixture from the skillet and set aside. \n5. Preheat your grill or stovetop grill pan to medium-high heat. \n6. Divide the ground beef into 4 equal portions and shape them into burger patties. \n7. Season the patties with salt and pepper on both sides. \n8. Brush the grill grates with olive oil to prevent sticking. \n9. Place the burger patties on the grill and cook for about 4-5 minutes per side for medium doneness. \n10. During the last minute of cooking, place a slice of Swiss cheese on each patty to allow it to melt. \n11. Remove the burger patties from the grill and let them rest for a few minutes. \n12. Toast the burger buns on the grill or in a toaster until lightly golden. \n13. Assemble the burgers by placing a patty on the bottom bun. \n14. Top with the onion and mushroom mixture. \n15. Add any optional toppings such as lettuce, tomato, caramelized onions, ketchup, or mustard. \n16. Place the top bun on the burger and serve immediately. \n17. Enjoy your delicious gourmet mushroom Swiss burgers!"
    
    @IBAction func cookButtonTapped(_ sender: Any) {
//        let shared = ResponseObject.shared
//        Task {
//            shared.response.removeAll()
//            let response = await OpenAIService.shared.sendMessage(messages: [
//                Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
//                Message(id: UUID().uuidString, role: .user, content: "Generate a recipe title and list of ingredients based on this request: \(promptTextField.text!)")
//            ])
//
//            let ingredientResponse = response?.choices[0].message.content
//            if let firstResponse = ingredientResponse {
//                shared.response.append(firstResponse)
//            }
//            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
//
//            let response2 = await OpenAIService.shared.sendMessage(messages: [
//                Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
//                Message(id: UUID().uuidString, role: .user, content: "Generate only steps for how to prepare this recipe in the format 1. 2. 3. etc. based on this list of ingredients: \(ingredientResponse!)")
//            ])
//
//            let stepsResponse = response2?.choices[0].message.content
//            if let secondResponse = stepsResponse {
//                ResponseObject.convertStepsToList(input: secondResponse, modify: &shared.response)
//            }
//            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
//        }
        let shared = ResponseObject.shared
        shared.response.removeAll()
        shared.response.append(testObject1)
        ResponseObject.convertStepsToList(input: testObject2, modify: &shared.response)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
        }
    }
    
    @IBSegueAction func toStepsView(_ coder: NSCoder) -> StepsViewController? {
        let stepsView = StepsViewController(coder: coder)
        
        return stepsView
    }

}
