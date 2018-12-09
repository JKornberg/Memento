//
//  PresentCard.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/30/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class PresentCardController: CardDisplayController {
    
    //Mark: - Setup Layout
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    private func setupLayout(){
        
        cardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 50,left: 15, bottom: 100, right: 15))
        
        //cardView.anchorToView(view: fullView, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        cardFront.anchorToView(view: cardView)
        cardBack.anchorToView(view: cardView)
        textViewFront.anchorToView(view: cardFront, padding: .init(top: topOffset, left: 0, bottom: bottomOffset, right: 0))
        textViewBack.anchorToView(view: cardBack, padding: .init(top: topOffset, left: 0, bottom: bottomOffset, right: 0))
        
        //Sets up constraints for the text at bottom of card
        correctButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.4).isActive = true
        correctButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        correctButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -5).isActive = true
        correctButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 10).isActive = true
        
        incorrectButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 5).isActive = true
        incorrectButton.heightAnchor.constraint(equalTo: correctButton.heightAnchor).isActive = true
        incorrectButton.widthAnchor.constraint(equalTo: correctButton.widthAnchor, multiplier: 1).isActive = true
        incorrectButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 10).isActive = true
    }
    
    override func addPoints(_ sender: UIButton) {
        super.addPoints(sender)
        navigationController?.popViewController(animated: true)
    }
    
    override func removePoints(_ sender: UIButton) {
        super.removePoints(sender)
        navigationController?.popViewController(animated: true)
    }

    
    //MARK: - Set styles
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /// Force the text in a UITextView to always center itself.
}

