//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CheckMarkView
import SwipeCellKit

protocol CellDelegate{
    func toggleSet(setID: Int, val: Bool)
}

class SetCell: SwipeTableViewCell {
    @IBOutlet weak var checkView: CheckMarkView!
    @IBOutlet weak var CellSuperView: UIView!
    @IBOutlet weak var title: UILabel!
    var checkDelegate : CellDelegate? = nil
    var setID = Int()
    var setName : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        checkView.style = .openCircle
        checkView.setNeedsDisplay()
        /*
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        checkView.heightAnchor.constraint(equalToConstant: 60).isActive = true */
        let tapCheck = UITapGestureRecognizer(target: self, action: #selector(toggleCheck))
        checkView.addGestureRecognizer(tapCheck)
    }
    @IBAction func toggleCheck(_ gestureRecognizer : UITapGestureRecognizer){
        if gestureRecognizer.state == .ended{
            checkView.checked = !checkView.checked
            checkDelegate!.toggleSet(setID:setID,val:checkView.checked)
        }
    }
    
    
}
