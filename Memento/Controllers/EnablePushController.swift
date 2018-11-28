//
//  EnablePushController.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/24/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class EnablePushController: UIViewController {

    @IBOutlet weak var closeButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeWindow(_:)))
        closeButton.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeWindow(_ gestureRecognizer : UITapGestureRecognizer){
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .ended{
            self.dismiss(animated: true) {
                print("popped")
            }
        }
    }

    @IBAction func goToSettingsAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
