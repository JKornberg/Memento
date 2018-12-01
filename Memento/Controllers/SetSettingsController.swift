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

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var durationPicker: UIDatePicker!
    let realm = try! Realm()
    var timeChanged : Bool = false
    var selectedSet : cardSet?
    var setController : SetController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameField.placeholder = selectedSet?.title
        if let timeInterval = selectedSet?.duration.value{
            durationPicker.countDownDuration = timeInterval
        } else{
            let defaults = UserDefaults.standard
            durationPicker.countDownDuration = defaults.double(forKey: "timeInterval")
        }
    }
    
    @IBAction func durationChanged(_ sender: UIDatePicker) {
        print(durationPicker.countDownDuration)
        timeChanged = true
    }
    @IBAction func saveDuration(_ sender: Any) {
        timeChanged = false
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
    @IBAction func clearDuration(_ sender: Any) {
        timeChanged = false
        if let set = selectedSet{
            do{
                try realm.write {
                    set.duration.value = nil
                }
            } catch{
                print("Error changing duration: \(error)")
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
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
    
    @IBAction func saveAction(_ sender: Any) {
        if timeChanged{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Save and Change Duration", style: .default) { (UIAlertAction) in
                self.saveSettings(includeTime:true)
            }
            let noAction = UIAlertAction(title: "Do Not Change Duration", style: .destructive) { (UIAlertAction) in
                self.saveSettings(includeTime: false)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            alert.addAction(cancel)
            present(alert, animated: true)
        } else{
            saveSettings(includeTime: false)
        }
    }
    
    func saveSettings(includeTime:Bool){
        if let set = selectedSet{
            do{
                try realm.write {
                    set.title = nameField.text!
                    if includeTime{
                        set.duration.value = durationPicker.countDownDuration
                    }
                }
            } catch{
                print("Error changing settings: \(error)")
            }
        }
        setController?.SetTableView.reloadData()
        dismiss(animated: true) {
            
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
