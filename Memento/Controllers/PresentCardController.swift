//
//  PresentCard.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/30/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class PresentCardController: UIViewController {
    
    
    let createContent = { (text : String) -> UITextView in
        let text = UITextView()
        return text
    }
    
    let cardFront : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let correctButton : UIButton = {
        let button = UIButton(type: .system)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(cardFront)
        let contentView = createContent("Sample Text")
        view.addSubview(contentView)
        setupLayout()
        createShadow(view: cardFront)
    }
    
    private func setupLayout(){
        cardFront.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        cardFront.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardFront.widthAnchor.constraint(equalToConstant: 310).isActive = true
        cardFront.heightAnchor.constraint(equalToConstant: 186).isActive = true
    }

    
    func createShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        let shadowPath = CGPath(rect: CGRect(x: 0,
                                             y:  5,
                                             width: view.layer.bounds.width,
                                             height: view.layer.bounds.height), transform: nil)
        
        view.layer.shadowPath = shadowPath
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
