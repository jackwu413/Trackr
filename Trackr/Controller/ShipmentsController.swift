//
//  ShipmentsController.swift
//  Trackr
//
//  Created by Jack on 4/9/20.
//  Copyright © 2020 Jack Wu. All rights reserved.
//

import UIKit

class ShipmentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Incoming Packages"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: cellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ItemCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

class ItemCell: BaseCell {
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark.circle")
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
//        backgroundColor = .blue
        addSubview(checkImageView)
        addConstraintsWithFormat(format: "H:[v0(68)]-12-|", views: checkImageView)
        addConstraintsWithFormat(format: "V:|-16-[v0(68)]", views: checkImageView)
        
        addSubview(dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .blue
    }
}
