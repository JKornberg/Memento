//
//  PresentQuizController.swift
//  Memento
//
//  Created by Jonah Kornberg on 12/5/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class PresentQuizController: CardDisplayController {
    
    private let cardCount : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var quizOrder : [Int]?
    var currentCard : Int = 0

    var set : cardSet?{
        didSet{
            if let count = set?.cards.count{
                let intSet = 0..<count
                quizOrder = intSet.shuffled()
                cardCount.text = "1/\(count)"
                card = set?.cards[quizOrder![0]]
                print(quizOrder)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View did load: \(cardView.frame.size.height)")
        setupLayout()
        setupStackView()
    }

    func setupLayout(){
        cardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20,left: 15, bottom: 150, right: 15))
        
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
    
    func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [cardCount])
        view.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor( leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func nextCard(){
        currentCard += 1
        card = set?.cards[(quizOrder?[currentCard])!]
        let activeView = isFront ? cardFront : cardBack
        let newViews = makeNewCardFront()
        let newFront = newViews.0
        let newTextFront = newViews.1
        cardCount.text = "\(currentCard+1)/" + (cardCount.text?.split(separator: "/")[1])!
        UIView.transition(from: activeView, to: newFront, duration: 0.5, options: [.showHideTransitionViews, .transitionCurlUp], completion: nil)
        layoutNewCard(view: newFront, text: newTextFront)
        
    }
    
    func makeNewCardFront()->(UIView,UITextView){
        let newFront = UIView()
        let newTextFront = createText()
        newTextFront.text = card?.side1
        cardView.addSubview(newFront)
        newFront.addSubview(newTextFront)
        newFront.backgroundColor = .white
        newFront.isHidden = true
        newFront.anchorToView(view: cardView)
        newTextFront.anchorToView(view: newFront, padding: .init(top: topOffset, left: 0, bottom: bottomOffset, right: 0))
        return (newFront,newTextFront)
    }
    
    func layoutNewCard(view: UIView, text: UITextView){
        cardFront.removeFromSuperview()
        isFront = true
        textViewBack.text = card?.side2
        cardFront = view
        textViewFront = text
        cardFront.addSubview(flipView)
        layoutFlipView()
        setFontSize()
        adjustContentSize()
        let tapFront = UITapGestureRecognizer(target: self, action: #selector(self.flipCard(_:)))
        cardFront.addGestureRecognizer(tapFront)
    }
    
    override func addPoints(_ sender: UIButton) {
        super.addPoints(sender)
        if currentCard + 1 < quizOrder?.count ?? 0{
            nextCard()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func removePoints(_ sender: UIButton) {
        super.removePoints(sender)
        if currentCard + 1 < quizOrder?.count ?? 0{
            nextCard()
        } else {
            navigationController?.popViewController(animated: true)
        }
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
