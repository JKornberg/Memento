//
//  ViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/19/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
import UserNotifications
class HomeController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var SetButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerDefaults()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPiece(_:)))
        SetButton.addGestureRecognizer(tap)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.flatMintDark
    }
    
    func registerDefaults(){
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["timeInterval": 3600])
    }
    
    @IBAction func tapPiece(_ gestureRecognizer : UITapGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .ended {      // Move the view down and to the right when tapped.
            performSegue(withIdentifier: "toSetView", sender: self)
        }}
}

