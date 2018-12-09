//
//  Extensions.swift
//  Memento
//
//  Created by Jonah Kornberg on 12/3/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchorToView(view : UIView, padding : UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.left).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.right).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,  trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero ) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIColor{
    static let watermelon = UIColor(hexString: "FF1451")
    static let lightmelon = UIColor(hexString: "EF5777")
    static let deepblue = UIColor(hexString: "1B3B57")
}
