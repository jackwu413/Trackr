//
//  CustomTabBarController.swift
//  Trackr
//
//  Created by Jack on 4/9/20.
//  Copyright © 2020 Jack Wu. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize incoming and outgoing nav controllers
        let inLayout = UICollectionViewFlowLayout()
        let inController = ShipmentsController(collectionViewLayout: inLayout)
        let incomingNavController = UINavigationController(rootViewController: inController)
        incomingNavController.tabBarItem.title = "Incoming"
        incomingNavController.tabBarItem.image = UIImage(systemName: "arrow.down")

        let outLayout = UICollectionViewFlowLayout()
        let outController = ShipmentsController(collectionViewLayout: outLayout)
        let outgoingNavController = UINavigationController(rootViewController: outController)
        outgoingNavController.tabBarItem.title = "Outgoing"
        outgoingNavController.tabBarItem.image = UIImage(systemName: "arrow.up")
        
        viewControllers = [incomingNavController, outgoingNavController]
        
        
        
    }
    
}

