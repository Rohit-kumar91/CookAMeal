//
//  RestaurantPreviewView.swift
//  googlMapTutuorial2
//
//  Created by Muskan on 12/17/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Foundation
import UIKit

class RestaurantPreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.clipsToBounds=true
        self.layer.masksToBounds=true
        setupViews()
    }
    
    func setData(title: String, img: String, price: Int) {
        lblTitle.text = title
        imgView.sd_setImage(with: URL(string: img), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        lblPrice.text = "$\(price)"
    }
    
    func setupViews() {
        
        addSubview(containerView)

        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true

        
        addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        //imgView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        imgView.bottomAnchor.constraint(equalTo:bottomAnchor).isActive=true
        imgView.widthAnchor.constraint(equalToConstant: 37).isActive=true
        
//        containerView.addSubview(lblTitle)
//        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive=true
//        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive=true
//        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive=true
//        lblTitle.heightAnchor.constraint(equalToConstant: 35).isActive=true

       

//        addSubview(lblPrice)
//        lblPrice.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
//        lblPrice.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive=true
//        lblPrice.leadingAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
//        lblPrice.widthAnchor.constraint(equalToConstant: 90).isActive=true
//        lblPrice.heightAnchor.constraint(equalToConstant: 40).isActive=true
    }
    
    let containerView: UIView = {
        let v=UIView()
        v.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.image=#imageLiteral(resourceName: "cook")
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblPrice: UILabel = {
        let lbl=UILabel()
        lbl.text="$12"
        lbl.font=UIFont.boldSystemFont(ofSize: 32)
        lbl.textColor=UIColor.white
        lbl.backgroundColor=UIColor(white: 0.2, alpha: 0.8)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds=true
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
