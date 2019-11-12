//
//  CollectionViewCell.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/9/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var DeleteIcon: UIImageView!
    
    var isDeleting: Bool = false {
        didSet {
            DeleteIcon.isHidden = !isDeleting
            print(isDeleting)
        }
    }
    
    @objc func deleteIconTapped() {
        
    }
    
    func configureUI() {
        self.contentView.layer.cornerRadius = self.frame.height/10
        self.contentView.clipsToBounds = true
        
        self.layer.cornerRadius = self.frame.height/10
        self.clipsToBounds = true
        
        setShadow()
    }
    
    func configureDefaultImage() {
        setDefaultImage()
        
        self.contentView.layer.cornerRadius = self.frame.height/10
        self.contentView.clipsToBounds = true

        self.layer.cornerRadius = self.frame.height/10
        self.clipsToBounds = true
        
        setShadow()

        isDeleting = false
    }
    
    func setDefaultImage() {
        let image = UIImage(named: "green camera")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: self.frame.width/8*3, y: self.frame.height/8*3, width: self.frame.width/4, height: self.frame.height/4)
        Image.addSubview(imageView)
    }
    
    func setShadow() {
        self.layer.shadowColor = GlobalTeal.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 50
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func handleSelectedImage(for image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        Image.addSubview(imageView)
        isDeleting = false
    }

}
