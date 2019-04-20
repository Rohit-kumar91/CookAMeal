//
//  ExpandableHeaderView.swift
//  TableViewDropDown
//
//  Created by BriefOS on 5/3/17.
//  Copyright © 2017 BriefOS. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, section: Int, profileImage: String, radioCheck: String, delegate: ExpandableHeaderViewDelegate) {
        
        if radioCheck == "1" {
            radioImageview.image = #imageLiteral(resourceName: "radioIcon")
            radioImageview.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        } else{
            radioImageview.layer.cornerRadius = 13
            radioImageview.layer.borderWidth = 2
            radioImageview.layer.borderColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        }
        
        self.cookName.text = title
        self.imgView.sd_setImage(with: URL(string: profileImage), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        self.section = section
        self.delegate = delegate
        
        print(radioCheck)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.black
        
        
        
        self.contentView.addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        imgView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 50).isActive=true
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive=true
        

        self.contentView.addSubview(cookName)
        cookName.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        cookName.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        
        self.contentView.addSubview(kitchenName)
        kitchenName.topAnchor.constraint(equalTo: cookName.bottomAnchor, constant: 2).isActive = true
        kitchenName.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        kitchenName.widthAnchor.constraint(equalToConstant: 50).isActive=true
        
        self.contentView.addSubview(radioImageview)
        radioImageview.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        radioImageview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        radioImageview.widthAnchor.constraint(equalToConstant: 26).isActive=true
        radioImageview.heightAnchor.constraint(equalToConstant: 26).isActive=true
        
        
    }

   
    let imgView: UIImageView = {
        let v=UIImageView()
        v.layer.cornerRadius = 25
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let cookName: UILabel = {
        let lbl=UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.black
        //lbl.text = "Rohit"
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let kitchenName: UILabel = {
        let lbl=UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = UIColor.white
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 5
        lbl.text = "Kitchen"
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let radioImageview : UIImageView = {
        let v=UIImageView()
        v.layer.cornerRadius = 13
        v.layer.borderWidth = 2
        v.layer.borderColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    

}
