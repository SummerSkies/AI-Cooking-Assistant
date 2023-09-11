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
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var stepNumberStack: UIStackView!
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var indexBeingDisplayed: Int = 0
    let shared = ResponseObject.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: NotificationManager.didReceiveNetworkResponse, object: nil)
        instructionsLabel.lineBreakMode = .byWordWrapping // or .byCharWrapping
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityLabel.isHidden = true
        ingredientListStack.isHidden = true
        ingredientsLabel.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationManager.didReceiveNetworkResponse, object: nil)
    }
    
    @objc func updateUI() {
        if indexBeingDisplayed == 0 {
            stepNumberLabel.text = "Your generated recipe:"
        } else {
            stepNumberLabel.text = "Step #\(indexBeingDisplayed)"
        }
        instructionsLabel.text = shared.response[indexBeingDisplayed]
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if indexBeingDisplayed != shared.response.count - 1 {
            indexBeingDisplayed += 1
            updateUI()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        if indexBeingDisplayed != 0 {
            indexBeingDisplayed -= 1
            updateUI()
        }
    }
}
