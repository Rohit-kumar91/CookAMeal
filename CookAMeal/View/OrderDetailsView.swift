//
//  OrderDetailsView.swift
//  sample
//
//  Created by CYNOMAC001 on 17/04/18.
//  Copyright © 2018 CYNOMAC001. All rights reserved.
//

import UIKit

class OrderDetailsView: UIView {

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.clipsToBounds=true
        self.layer.masksToBounds=true
        setupViews()
    }
    
    func setData(recipeName: String, img: String,  spiceLevel: String, serve: String, price: String, currencySymbol: String) {
        recipeTitle.text = recipeName
        imgView.sd_setImage(with: URL(string: img), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        self.spiceLevel.text = spiceLevel
        self.serve.text = serve
        self.price.text = currencySymbol + price
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
        imgView.widthAnchor.constraint(equalToConstant: 60).isActive=true
        imgView.heightAnchor.constraint(equalToConstant: 60).isActive=true
        
        containerView.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive=true
        stackView.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 0).isActive=true
        stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive=true
        
        stackView.addArrangedSubview(recipeTitle)
        stackView.addArrangedSubview(spiceLevel)
        stackView.addArrangedSubview(serve)
        stackView.addArrangedSubview(price)
        
        
    }
    
    
    let containerView: UIView = {
        let v=UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.layer.cornerRadius = 6
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let recipeTitle: UILabel = {
        let lbl=UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 1
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let serve: UILabel = {
        let lbl=UILabel()
        lbl.font = UIFont(name:"Helvetica Neue", size: 13)
        lbl.textColor=UIColor.black
        lbl.textAlignment = .left
        lbl.clipsToBounds=true
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let spiceLevel: UILabel = {
        let lbl=UILabel()
        lbl.font = UIFont(name:"Helvetica Neue", size: 13)
        lbl.textColor=UIColor.black
        lbl.textAlignment = .left
        lbl.clipsToBounds=true
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let price: UILabel = {
        let lbl=UILabel()
        lbl.font = UIFont(name:"Helvetica Neue", size: 13)
        lbl.textColor=UIColor.black
        lbl.textAlignment = .left
        lbl.clipsToBounds=true
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis  = .vertical
        stack.distribution  = .fillEqually
        stack.alignment = .fill
        stack.spacing   = 1
        stack.translatesAutoresizingMaskIntoConstraints=false
        
        return stack
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
