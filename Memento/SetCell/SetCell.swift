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
    func quiz(setID: Int)
}

class SetCell: SwipeTableViewCell {
    @IBOutlet weak var favoriteButton: UIButton!
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
        activeButton.setImage(UIImage(named: "activeNotification-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func setUncheckedStyle(){
        activeButton.setImage(UIImage(named: "inactiveNotification-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    @IBAction func toggleActive(_ sender: Any) {
        cellDelegate?.toggleSet(setID: setID)
        setStyle()
    }
    @IBAction func quizAction(_ sender: Any)
    {
        cellDelegate?.quiz(setID: setID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setStyle()
        favoriteButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.setTitle("Quiz", for: .normal)
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5) 
        favoriteButton.layer.borderColor = UIColor.white.cgColor
        favoriteButton.layer.borderWidth = 1
        favoriteButton.layer.cornerRadius = 5
        favoriteButton.tintColor = UIColor.white
        activeButton.tintColor = UIColor.white
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        let favoriteImage = UIImage(named: "quiz-icon")?.withRenderingMode(.alwaysTemplate)
        let quizHighlightImage = UIImage(named: "quizHighlighted-icon")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(favoriteImage, for: .normal)
        favoriteButton.setImage(quizHighlightImage, for: .highlighted)
//        let notImage = UIImage(named: "inactiveNotification-icon")?.withRenderingMode(.alwaysTemplate)
//        activeButton.setImage(notImage, for: .normal)
    }


    
    
}
