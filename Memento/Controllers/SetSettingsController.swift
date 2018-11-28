//
//  SetSettingsController.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/28/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
import RealmSwift

class SetSettingsController: UIViewController {

    @IBOutlet weak var durationPicker: UIDatePicker!
    @IBOutlet weak var closeButton: UIImageView!
    let realm = try! Realm()

    var selectedSet : Set?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonPressed(_:)))
        closeButton.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func durationChanged(_ sender: UIDatePicker) {
        print(sender.countDownDuration)
    }
    
    @IBAction func closeButtonPressed(_ gestureRecognizer: UITapGestureRecognizer){
        guard gestureRecognizer.view != nil else {return}
        if gestureRecognizer.state == .ended{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
                print("Cancelled")
            }
            let closeNoSave = UIAlertAction(title: "Do Not Save", style: .destructive) { (UIAlertAction) in
                self.dismiss(animated: true, completion: {
                    
                })
            }
            alert.addAction(cancelAction)
            alert.addAction(closeNoSave)
            present(alert, animated: true)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveDuration()
        dismiss(animated: true) {
            
        }
    }
    
    func saveDuration(){
        if let set = selectedSet{
            do{
                try realm.write {
                    set.duration.value = durationPicker.countDownDuration
                }
            } catch{
                print("Error changing duration: \(error)")
            }
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
