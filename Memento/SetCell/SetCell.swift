//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol CellDelegate{
    func toggleSet(setID: Int)
}

class SetCell: SwipeTableViewCell {
    @IBOutlet weak var CellSuperView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activeButton: UIButton!
    var checkDelegate : CellDelegate? = nil
    var setID = Int()
    var setName : String = ""
    var checked : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }
    
    func setStyle(){
        if checked{
            setCheckedStyle()
        } else { setUncheckedStyle()}
    }
    
    func setCheckedStyle(){
        activeButton.backgroundColor = UIColor.blue
        activeButton.setTitleColor(UIColor.white, for: .normal)
        activeButton.setTitle("Active Set", for: .normal)
    }
    
    func setUncheckedStyle(){
        activeButton.backgroundColor = UIColor.white
        activeButton.layer.cornerRadius = 10
        activeButton.layer.borderColor = UIColor.blue.cgColor
        activeButton.layer.borderWidth = 2.0;
        activeButton.setTitleColor(UIColor.red, for: .normal)
        activeButton.setTitle("Inactive Set", for: .normal)
    }
    @IBAction func toggleActive(_ sender: Any) {
        checkDelegate?.toggleSet(setID: setID)
        setStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setStyle()
        /*
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        checkView.heightAnchor.constraint(equalToConstant: 60).isActive = true */
    }

    
    
}
