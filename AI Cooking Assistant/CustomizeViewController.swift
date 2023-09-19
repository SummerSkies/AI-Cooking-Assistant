//
//  CustomizeViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/18/23.
//

import UIKit

class CustomizeViewController: UIViewController {
    
    @IBOutlet weak var numberOfPeopleTextField: UITextField!
    @IBOutlet weak var badIngredientsTextField: UITextField!
    
    var formView: FormViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfPeopleTextField.keyboardType = .numberPad
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        formView?.numberOfPeople = numberOfPeopleTextField.text!
        formView?.badIngredients = badIngredientsTextField.text!
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
}
