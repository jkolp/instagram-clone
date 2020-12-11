//
//  CustomTextField.swift
//  instagram_clone
//
//  Created by Projects on 11/21/20.
//

import UIKit

class CustomTextField: UITextField {
    
     init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = UITextField.BorderStyle.none
        textColor = .white
        keyboardAppearance = .dark
        keyboardType = UIKeyboardType.emailAddress
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.7)])   // placeholder text
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
