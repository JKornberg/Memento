//
//  PresentCard.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/30/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class PresentCardController: UIViewController {
    
    
    
    var card : Card? {
        didSet{
            setupCard()
        }
    }
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .blue
        textView.font = UIFont.systemFont(ofSize: 30)
        return textView
    }()
    
    let createContent = { (text : String) -> UITextView in
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }
    
    let cardFront : UIView = {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(cardFront)
        cardFront.addSubview(textView)
        setupLayout()
        createShadow(view: cardFront)
    }
    
    func setupCard(){
        textView.text = card?.side1
    }
    
    private func setupLayout(){
        cardFront.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        cardFront.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        cardFront.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        cardFront.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        textView.leftAnchor.constraint(equalTo: cardFront.leftAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: cardFront.rightAnchor, constant: 0).isActive = true
        textView.topAnchor.constraint(equalTo: cardFront.topAnchor, constant: 30).isActive = true
        let height = cardFront.frame.size.height
        //textView.heightAnchor.constraint(lessThanOrEqualTo: cardFront.heightAnchor, multiplier: 1).isActive = true
        textView.bottomAnchor.constraint(equalTo: cardFront.bottomAnchor, constant: -30).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFontSize()
        adjustContentSize(tv: textView)

    }
    //textView is the actual text view
    func setFontSize(){
        var fontSize = 30.0
        let minSize = 12
        let testTextView = UITextView()
        testTextView.text = textView.text
        testTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        var newHeight = testTextView.sizeThatFits(CGSize(width: cardFront.frame.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        //print("Frame Height: \(cardFront.frame.size.height)")
        while (newHeight >= cardFront.frame.size.height-60){
            //print("Size required: \(newHeight)")
            fontSize -= 0.5
            testTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            newHeight = testTextView.sizeThatFits(CGSize(width: cardFront.frame.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        }
        //print("Size required: \(testTextView.sizeThatFits(CGSize(width: cardFront.frame.width, height: CGFloat(Float.greatestFiniteMagnitude))).height)")
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
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
        tv.contentSize = newTextView.sizeThatFits(CGSize(width: cardFront.frame.width, height: CGFloat(Float.greatestFiniteMagnitude)))
        print(cardFront.bounds.size.height)
        print(tv.contentSize.height)
        let deadSpace = cardFront.bounds.size.height - 60 - tv.contentSize.height
        print(deadSpace)
        let inset = max(0, deadSpace/2.0)
        print(inset)
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

extension UITextView {
    
    /// Modifies the top content inset to center the text vertically.
    ///
    /// Use KVO on the UITextView contentSize and call this method inside observeValue(forKeyPath:of:change:context:)
}
