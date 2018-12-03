//
//  PresentCard.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/30/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class PresentCardController: UIViewController {
    
    
    let topOffset : CGFloat = 30
    let bottomOffset : CGFloat = 70
    var isFront = true
    var card : Card? {
        didSet{
            setupCard()
        }
    }
    
    let cardView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textViewFront : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .blue
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let cardFront : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textViewBack : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .blue
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 30)
        return textView
    }()
    
    let cardBack : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let correctButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I Know It", for: .normal)
        return button
    }()
    
    let incorrectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I Don't Know It", for: .normal)
        return button
    }()
    
    let flipView : UIView = {
        let view = Bundle.main.loadNibNamed("flipView", owner: self, options: nil)?.first as? UIView
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(cardView)
        cardView.addSubview(cardFront)
        cardView.addSubview(cardBack)
        cardBack.isHidden = true
        cardBack.addSubview(textViewBack)
        cardFront.addSubview(flipView)
        cardFront.addSubview(textViewFront)
        
        setupLayout()
        let tapFront = UITapGestureRecognizer(target: self, action: #selector(self.flipCard(_:)))
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(self.flipCard(_:)))
        cardFront.addGestureRecognizer(tapFront)
        cardBack.addGestureRecognizer(tapBack)
        createShadow(view: cardFront)
    }
    
    func setupCard(){
        textViewFront.text = card?.side1
        textViewBack.text = card?.side2
    }
    
    
    @IBAction func flipCard(_ gesture: UITapGestureRecognizer){
        guard gesture.view != nil else{return}
        if gesture.state == .ended{
            let fromView = isFront ? cardFront : cardBack
            let toView = isFront ? cardBack : cardFront
            UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            toView.translatesAutoresizingMaskIntoConstraints = false
            isFront = !isFront
            setFontSize()
            switch isFront{
            case true:
                adjustContentSize(tv: textViewFront)
            case false:
                adjustContentSize(tv: textViewBack)
            }
        }
    }
    
    private func setupLayout(){
        
        cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        cardView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        cardView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).isActive = true
        
        cardFront.topAnchor.constraint(equalTo: cardView.topAnchor).isActive = true
        cardFront.leftAnchor.constraint(equalTo: cardView.leftAnchor).isActive = true
        cardFront.rightAnchor.constraint(equalTo: cardView.rightAnchor).isActive = true
        cardFront.bottomAnchor.constraint(equalTo: cardView.bottomAnchor).isActive = true
        
        cardBack.topAnchor.constraint(equalTo: cardView.topAnchor).isActive = true
        cardBack.leftAnchor.constraint(equalTo: cardView.leftAnchor).isActive = true
        cardBack.rightAnchor.constraint(equalTo: cardView.rightAnchor).isActive = true
        cardBack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor).isActive = true

        
        textViewFront.leftAnchor.constraint(equalTo: cardFront.leftAnchor, constant: 0).isActive = true
        textViewFront.rightAnchor.constraint(equalTo: cardFront.rightAnchor, constant: 0).isActive = true
        textViewFront.topAnchor.constraint(equalTo: cardFront.topAnchor, constant: topOffset).isActive = true
        textViewFront.bottomAnchor.constraint(equalTo: cardFront.bottomAnchor, constant: -bottomOffset).isActive = true
        
        textViewBack.leftAnchor.constraint(equalTo: cardBack.leftAnchor, constant: 0).isActive = true
        textViewBack.rightAnchor.constraint(equalTo: cardBack.rightAnchor, constant: 0).isActive = true
        textViewBack.topAnchor.constraint(equalTo: cardBack.topAnchor, constant: topOffset).isActive = true
        textViewBack.bottomAnchor.constraint(equalTo: cardBack.bottomAnchor, constant: -bottomOffset).isActive = true
        
        flipView.leftAnchor.constraint(equalTo: cardFront.leftAnchor, constant: 0).isActive = true
        flipView.rightAnchor.constraint(equalTo: cardFront.rightAnchor, constant: 0).isActive = true
        flipView.topAnchor.constraint(equalTo: textViewFront.bottomAnchor, constant: 0).isActive = true
        flipView.bottomAnchor.constraint(equalTo: cardFront.bottomAnchor, constant: 0).isActive = true


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFontSize()
        switch isFront{
        case true:
            adjustContentSize(tv: textViewFront)
        case false:
            adjustContentSize(tv: textViewBack)
        }
        createShadow(view: cardFront)
        
    }
    
    //textView is the actual text view
    func setFontSize(){
        var fontSize = 30.0
        let testTextView = UITextView()
        let baseTextView = isFront ? textViewFront : textViewBack
        testTextView.text = baseTextView.text
        testTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        var newHeight = testTextView.sizeThatFits(CGSize(width: cardView.frame.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        //print("Frame Height: \(cardFront.frame.size.height)")
        while (newHeight >= cardView.frame.size.height-(topOffset+bottomOffset)){
            //print("Size required: \(newHeight)")
            fontSize -= 0.2
            testTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            newHeight = testTextView.sizeThatFits(CGSize(width: cardView.frame.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        }
        //print("Size required: \(testTextView.sizeThatFits(CGSize(width: cardFront.frame.width, height: CGFloat(Float.greatestFiniteMagnitude))).height)")
        textViewFront.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        //print("Set Font to \(fontSize)")
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
    
    func adjustContentSize(tv: UITextView){
        let newTextView = UITextView()
        newTextView.font = tv.font
        newTextView.text = tv.text
        tv.contentSize = newTextView.sizeThatFits(CGSize(width: cardView.frame.width, height: CGFloat(Float.greatestFiniteMagnitude)))
        let deadSpace = cardView.bounds.size.height - (topOffset+bottomOffset) - tv.contentSize.height
        let inset = max(0, deadSpace/2.0)
        tv.textContainerInset = UIEdgeInsets(top: inset, left: tv.contentInset.left, bottom: inset, right: tv.contentInset.right)
    }
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
