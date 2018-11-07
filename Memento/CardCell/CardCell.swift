//
//  CardCell.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/25/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
class CardCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var side1: UITextField!
    @IBOutlet var side2: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        // Initialization code
        
    }
    override func layoutSubviews() {
        side1.setBottomBorder()
        side2.setBottomBorder()
    }
    
    
    
    
}
