//
//  Popup.swift
//  Trackr
//
//  Created by Jack on 4/29/20.
//  Copyright © 2020 Jack Wu. All rights reserved.
//

import UIKit

class Popup: UIView {
    
    let nameInput: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Item Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 8
        field.setLeftPaddingPoints(10)
        field.setRightPaddingPoints(10)
        return field
    }()

    let trackingInput: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Tracking Number"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 8
        field.setLeftPaddingPoints(10)
        field.setRightPaddingPoints(10)
        return field
    }()
    
    let uspsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("USPS", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let upsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("UPS", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let fedexButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("FedEx", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var carrierStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [uspsButton, upsButton, fedexButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        uspsButton.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.85).isActive = true
        uspsButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.3).isActive = true
        upsButton.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.85).isActive = true
        upsButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.3).isActive = true
        fedexButton.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.85).isActive = true
        fedexButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.3).isActive = true
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.backgroundColor = .cyan
        stack.axis = .horizontal
        return stack
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Done", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var actionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        cancelButton.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.85).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.45).isActive = true
        doneButton.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.85).isActive = true
        doneButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.45).isActive = true
        return stack
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameInput, trackingInput, carrierStack, actionStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        nameInput.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
        nameInput.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.85).isActive = true
        trackingInput.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
        trackingInput.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.85).isActive = true
        carrierStack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
        carrierStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.85).isActive = true
        actionStack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
        actionStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.85).isActive = true
        return stack
    }()
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        return v
    }()
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func animateIn() {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.containerView.transform = .identity
            self.alpha = 1
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        self.frame = UIScreen.main.bounds
        
        self.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true

        NSLayoutConstraint.activate([containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        NSLayoutConstraint.activate([containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        
        containerView.addSubview(mainStack)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: mainStack)
        containerView.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: mainStack)
        
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
