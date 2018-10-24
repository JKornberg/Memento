//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CheckMarkView

protocol CellDelegate{
    func toggleSet(setID: String, val: Bool)
}

class SetCell: UITableViewCell {
    
    @IBOutlet weak var checkView: CheckMarkView!
    @IBOutlet weak var CellSuperView: UIView!
    @IBOutlet weak var title: UILabel!
    var delegate : CellDelegate? = nil
    var setID : String = ""
    var setName : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("here")
        // Initialization code goes here
        checkView.style = .openCircle
        checkView.setNeedsDisplay()
        let tapCheck = UITapGestureRecognizer(target: self, action: #selector(toggleCheck))
        checkView.addGestureRecognizer(tapCheck)
    }
    
    @IBAction func toggleCheck(_ gestureRecognizer : UITapGestureRecognizer){
        if gestureRecognizer.state == .ended{
            checkView.checked = !checkView.checked
            delegate!.toggleSet(setID:setID,val:checkView.checked)
        }
    }
    
    
}
