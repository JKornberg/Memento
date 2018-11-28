//
//  EnablePushController.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/24/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class EnablePushController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true) {
            print("popped")
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
