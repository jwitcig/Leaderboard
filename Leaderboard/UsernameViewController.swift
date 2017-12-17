//
//  UsernameViewController.swift
//  Leaderboard
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import AnimatedTextInput
import Cartography

class UsernameViewController: UIViewController {

    var textField: AnimatedTextInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        let label = UILabel()
        label.text = "What should we call you?"
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 54)
        
        view.addSubview(label)
        
        constrain(label, view) {
            $0.centerY == $1.centerY// * 0.6
            $0.centerX == $1.centerX
            
            $0.width == $1.width * 0.8
        }
        
        textField = AnimatedTextInput()
        textField.type = .standard
        textField.style = UsernameTextInputStyle()
        textField.placeHolderText = "username"
        
        view.addSubview(textField)
        
        constrain(textField, view, label) {
            $0.topMargin == $2.bottom + 40
            $0.centerX == $1.centerX
            
            $0.width == $1.width * 0.6
            $0.height == 44
        }
    }
}

struct UsernameTextInputStyle: AnimatedTextInputStyle {
    var textAttributes: [String : Any]? = nil

    let yPlaceholderPositionOffset: CGFloat = 0
    let lineInactiveColor: UIColor = .white
    let activeColor = UIColor.blue
    let inactiveColor = UIColor.white.withAlphaComponent(0.3)
    let errorColor = UIColor.red
    let textInputFont = UIFont.systemFont(ofSize: 24)
    let textInputFontColor = UIColor.black
    let placeholderMinFontSize: CGFloat = 9
    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 9)
    let leftMargin: CGFloat = 0
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
}
