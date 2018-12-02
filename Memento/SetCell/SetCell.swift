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
    var cellDelegate : CellDelegate? = nil
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
        activeButton.setImage(UIImage(named: "activeNotification-icon"), for: .normal)
    }
    
    func setUncheckedStyle(){
        activeButton.setImage(UIImage(named: "inactiveNotification-icon"), for: .normal)
    }
    @IBAction func toggleActive(_ sender: Any) {
        cellDelegate?.toggleSet(setID: setID)
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
