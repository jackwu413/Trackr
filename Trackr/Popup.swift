//
//  Popup.swift
//  Trackr
//
//  Created by Jack on 4/29/20.
//  Copyright © 2020 Jack Wu. All rights reserved.
//

import UIKit

class Popup: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Enter Package Details"
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Extra Details"
        label.textAlignment = .center
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
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
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true

        NSLayoutConstraint.activate([containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        NSLayoutConstraint.activate([containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        
        containerView.addSubview(stack)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: stack)
        containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: stack)
        
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
