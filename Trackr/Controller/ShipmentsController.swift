//
//  ShipmentsController.swift
//  Trackr
//
//  Created by Jack on 4/9/20.
//  Copyright © 2020 Jack Wu. All rights reserved.
//

import UIKit

protocol PopupDelegate {
    func enterShipment(name: String, tracking: String, carrier: String)
}

class Item: NSObject {
    var name: String?
    var carrier: String?
    var tracking: String?
    var delivered: Bool?
    var daysLeft: String?
    var date: String?
    init (name: String, carrier: String, tracking: String) {
        self.name = name
        self.carrier = carrier
        self.tracking = tracking
    }
}

class ShipmentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PopupDelegate {
    
    private let cellID = "cellID"
    
    var items: [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Incoming Packages"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(optionsPressed))
        
        items = []
    }

    @objc func addPressed() {
        let popup = Popup()
        popup.delegate = self
        view.addSubview(popup)
    }
    
    func enterShipment(name: String, tracking: String, carrier: String) {
        print("\(name) is shipping with \(carrier). Tracking number is: \(tracking).")
        var newItem = Item(name: name, carrier: carrier, tracking: tracking)
        self.loadItemData(item: newItem)
        items?.append(newItem)
        collectionView.reloadData()
    }
    
    func loadItemData(item: Item) {
        
        var semaphore = DispatchSemaphore(value: 0)

        let url = URL(string: "https://api.shipengine.com/v1/tracking?carrier_code=\(item.carrier!)&tracking_number=\(item.tracking!)")!
        var request = URLRequest(url: url)
        request.addValue("api.shipengine.com", forHTTPHeaderField: "Host")
        request.addValue("TEST_1MQycNgLIWIkE4gaB54J2WS61gqSetWLbKhBTTbKHY4", forHTTPHeaderField: "API-Key")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                print(String(data: safeData, encoding: .utf8)!)
                //Parse JSON and assign values to item
                self.parseJSON(data: safeData, item: item)
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    func parseJSON(data: Data, item: Item) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ItemData.self, from: data)

            //set item.daysLeft
            if decodedData.status_code == "DE" {
                item.delivered = true
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                let deliveryDate = dateFormatter.date(from: decodedData.actual_delivery_date!)!
                //set item.date to "Delivered: MM/dd/yyyy"
                dateFormatter.dateFormat = "MM"
                let month = dateFormatter.string(from: deliveryDate)
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.string(from: deliveryDate)
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: deliveryDate)
                print("\(month)/\(day)/\(year)")
            } else {
                item.delivered = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                let estimatedDate = dateFormatter.date(from: decodedData.estimated_delivery_date!)!
                dateFormatter.dateFormat = "MM"
                let month = dateFormatter.string(from: estimatedDate)
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.string(from: estimatedDate)
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: estimatedDate)
                //set item.date to be "Estimated Delivery: MM/dd/yyyy" from estimatedDate
                item.date = "Estimated Delivery: \(month)/\(day)/\(year)"
                //set item.daysLeft to be (estimatedDate - today) if 1, delete s from "Days"
                let curr = Date()
                let daysBetween = Calendar.current.dateComponents([.day], from: curr, to: estimatedDate).day
                if daysBetween! <= 1{
                    item.daysLeft = "1 Day"
                } else {
                    item.daysLeft = "\(daysBetween) Days"
                }
            }
            print(item)
        } catch {
            print(error)
        }
    }
    
    
    @objc func optionsPressed() {
        print("options pressed")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = items?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ItemCell
  
        cell.item = items?[indexPath.item]
//
//        if cell.item?.expectedDate != nil {
//            cell.dateLabel.text = "Expected: \(cell.item?.expectedDate ?? "unavailable")"
//            cell.daysLeftLabel.text = "3 Days"
//            cell.checkImageView.isHidden = true
//            cell.daysLeftLabel.isHidden = false
//        }
        
//        if indexPath.row % 2 != 0 {
//            cell.checkImageView.isHidden = false
//            cell.daysLeftLabel.isHidden = true
//        } else {
//            cell.checkImageView.isHidden = true
//            cell.daysLeftLabel.isHidden = false
//        }
        
//        if let item = items?[indexPath.item] {
//
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

class ItemCell: BaseCell {
    
    var item: Item? {
        didSet {
            nameLabel.text = item?.name
            dateLabel.text = item?.date
            daysLeftLabel.text = item?.daysLeft
            if (item?.delivered)! {
                checkImageView.isHidden = false
                daysLeftLabel.isHidden = true
            } else {
                checkImageView.isHidden = true
                daysLeftLabel.isHidden = false
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Name"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date: "
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark.circle")
        return imageView
    }()
    
    let daysLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "3 Days"
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        
        setupContainerView()
        
        addSubview(checkImageView)
        addConstraintsWithFormat(format: "H:[v0(68)]-12-|", views: checkImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: checkImageView)
        NSLayoutConstraint.activate([checkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        addSubview(daysLeftLabel)
        addConstraintsWithFormat(format: "H:[v0(100)]-18-|", views: daysLeftLabel)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: daysLeftLabel)
        NSLayoutConstraint.activate([daysLeftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        addSubview(dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-150-|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(60)]", views: containerView)
        NSLayoutConstraint.activate([containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, dateLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: dateLabel)

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
