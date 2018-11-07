//
//  ViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/19/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var SetButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPiece(_:)))
	        SetButton.addGestureRecognizer(tap)
    }
    
    @IBAction func tapPiece(_ gestureRecognizer : UITapGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .ended {      // Move the view down and to the right when tapped.
            performSegue(withIdentifier: "toSetView", sender: self)
        }}

    


}

