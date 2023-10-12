//
//  CustomizeViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/18/23.
//

import UIKit

class CustomizeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var numberOfPeopleTextField: CustomTextView!
    @IBOutlet weak var badIngredientsTextField: CustomTextView!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var badIngredientsLabel: UILabel!
    
    var formView: FormViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfPeopleTextField.keyboardType = .numberPad
        
        numberOfPeopleTextField.delegate = self
        numberOfPeopleTextField.text = ""
        numberOfPeopleTextField.textColor = numberOfPeopleTextField.customGray
        badIngredientsTextField.delegate = self
        badIngredientsTextField.text = ""
        badIngredientsTextField.textColor = badIngredientsTextField.customGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        formView?.numberOfPeople = numberOfPeopleTextField.text!
        formView?.badIngredients = badIngredientsTextField.text!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let peopleFontSize = numberOfPeopleLabel.getFontSizeForLabel()
        let ingredientFontSize = badIngredientsLabel.getFontSizeForLabel()
        
        let smallestFontSize = min(peopleFontSize, ingredientFontSize)
        
        numberOfPeopleLabel.font = numberOfPeopleLabel.font.withSize(smallestFontSize)
        badIngredientsLabel.font = badIngredientsLabel.font.withSize(smallestFontSize)
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == numberOfPeopleTextField.customGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            if textView.textColor == badIngredientsTextField.customGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = ""
            textView.textColor = numberOfPeopleTextField.customGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else {
            if textView.textColor == numberOfPeopleTextField.customGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
            }
            if textView.textColor == badIngredientsTextField.customGray && !text.isEmpty {
                textView.textColor = UIColor.black
                textView.text = text
            }
            return true
        }
        return false
    }

}

extension UILabel {
    func getFontSizeForLabel() -> CGFloat {
        let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        text.setAttributes([NSAttributedString.Key.font: self.font!], range: NSMakeRange(0, text.length))
        let context: NSStringDrawingContext = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor
        text.boundingRect(with: self.frame.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: context)
        let adjustedFontSize: CGFloat = self.font.pointSize * context.actualScaleFactor
        return adjustedFontSize
    }
}
