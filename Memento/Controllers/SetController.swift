//
//  SetControllerViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
import SwipeCellKit
import CoreData
import RealmSwift
import UserNotifications
import ChameleonFramework
class SetController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    

    let realm = try! Realm()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    var selectedCardSet : cardSet?
    var setArray: Results<cardSet>?
    var saveAction : UIAlertAction!
    var selectedSettingCell : IndexPath?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var cardSetTableView: UITableView!
    let analArray = [UIColor(hexString: "EF5777"),UIColor(hexString: "FF2165"),UIColor(hexString: "FF1451"),UIColor(hexString: "E81E57"),UIColor(hexString: "D42151")]
    //let analArray = [UIColor(hexString: "EF5777"),UIColor(hexString: "E81E4D"),UIColor(hexString: "FF1451"),UIColor(hexString: "E81E57"),UIColor(hexString: "FF2165")]
//    let analArray = [UIColor(hexString: "EF5777"),UIColor(hexString: "FC4F5F"),UIColor(hexString: "F53B57"),UIColor(hexString: "FC4F88"),UIColor(hexString: "D8436C")]
    var analogousLoop : [UIColor?] {
        var array : [UIColor?] = analArray
        for i in analArray.reversed()[1...analArray.count-2]{
            array.append(i)
        }
        return array
    }
//    let analArray = NSArray(ofColorsWith: ColorScheme.analogous, using: UIColor.watermelon, withScheme: true) as! [UIColor]
    let triadArray = NSArray(ofColorsWith: ColorScheme.triadic, using: UIColor.watermelon, withFlatScheme: true) as! [UIColor]
    var colorIndex = 0
    var positive = true
    @IBAction func sortSets(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //loadData()
        view.backgroundColor = UIColor.flatMint
        navigationController?.navigationBar.barTintColor = .flatMintDark
        navigationController?.navigationBar.tintColor = .white
        cardSetTableView.backgroundColor = .flatMint
        setArray = appDelegate.setArray
        searchBar.delegate = self
        cardSetTableView.delegate = self
        cardSetTableView.dataSource = self
        cardSetTableView.register(UINib(nibName: "SetCell", bundle: nil), forCellReuseIdentifier: "customSetCell")
        cardSetTableView.rowHeight = 80
        cardSetTableView.separatorInset = .zero
        cardSetTableView.separatorStyle = .none
        cardSetTableView.separatorColor = triadArray[1]
        searchBar.barTintColor = UIColor.flatMint
        cardSetTableView.tableFooterView = UIView()
    }
    
    //TOPIC: - Delegate Functions
    func toggleSet(setID: Int) {
        checkNotifications(){
            do{
                try self.realm.write {
                    self.setArray![setID].isActive = !self.setArray![setID].isActive
                }
            } catch{
                print("error saving toggle")
            }
            self.colorIndex = 0
            self.cardSetTableView.reloadData()
            let set = self.setArray![setID]
            if set.isActive{
                self.appDelegate.scheduleNotifications(set: set)
            } else {
                self.appDelegate.cancelNotifications(set: set)
            }
        /*
        setArray[setID].isActive = val
        print("set \(setID) is \(val)")
             saveSets() */ }
    }
    
    func presentCard(set: cardSet){
        selectedCardSet = set
        performSegue(withIdentifier: "presentCard", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = cardSetTableView.dequeueReusableCell(withIdentifier: "customSetCell", for: indexPath) as! SetCell
        newCell.selectionStyle = .none
        newCell.delegate = self
        newCell.setID = indexPath.row
        newCell.title.text = setArray?[indexPath.row].title ?? "No sets added yet"
        newCell.cellDelegate = self
        newCell.checked = setArray?[indexPath.row].isActive ?? false
//        newCell.backgroundColor = analArray[colorIndex]
//        if positive{
//            colorIndex += 1
//            if colorIndex > 4{
//                colorIndex = colorIndex - 2
//                positive = false
//            }
//        } else{
//            colorIndex -= 1
//            if colorIndex < 0{
//                colorIndex += 2
//                positive = true
//            }
//        }
        return newCell
    }
    
    //    5 : 3 6: 2 7 : 1
    //    13 : 3
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = analogousLoop[indexPath.row%8]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenCardsSet", sender: self)
        cardSetTableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    //TOPIC: Manage Data
    func save(set: cardSet){
        do {
            try realm.write{
                realm.add(set)
            }
        } catch {
            print("Error saving context")
        }
        colorIndex = 0
        cardSetTableView.reloadData()
    }
    
    func loadData(){
        setArray = realm.objects(cardSet.self).sorted(byKeyPath: "dateCreated")
        colorIndex = 0
        cardSetTableView.reloadData()
    }
    
    func quiz(setID: Int){
        cardSetTableView.selectRow(at: IndexPath(row: setID, section: 0), animated: false, scrollPosition: .none)
        performSegue(withIdentifier: "PresentQuiz", sender: self)
        cardSetTableView.deselectRow(at: IndexPath(row: setID, section: 0), animated: false)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Set", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.delegate = self
        }
        saveAction = UIAlertAction(title: "Create", style: .default, handler: { (act) in
            let newSet = cardSet()
            newSet.title = textField.text!
            newSet.dateCreated = Date()
            self.save(set: newSet)
            self.cardSetTableView.selectRow(at: IndexPath(row: self.setArray!.count - 1, section: 0), animated: false, scrollPosition: .top)
            self.performSegue(withIdentifier: "OpenCardsSet", sender: self)
        })
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print(action)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCardsSet"{
            let dest = segue.destination as! CardsController
            if let indexPath = cardSetTableView.indexPathForSelectedRow {
                print("got it")
                dest.selectedSet = setArray?[indexPath.row]
            }
        } else if segue.identifier == "OpenSetSettings"{
            let dest = segue.destination as! SetSettingsController
            if let path = selectedSettingCell{
                dest.selectedSet = setArray?[path.row]
                dest.setController = self
            }
        } else if segue.identifier == "PresentCard"{
            let dest = segue.destination as! PresentCardController
            if let indexPath = cardSetTableView.indexPathForSelectedRow {
                dest.card = setArray?[indexPath.row].cards[0]
            }
        } else if segue.identifier == "PresentQuiz"{
            let dest = segue.destination as! PresentQuizController
            if let indexPath = cardSetTableView.indexPathForSelectedRow {
                dest.set = setArray?[indexPath.row]
            }
        }
    }
    
    func checkNotifications(handler: @escaping ()->Void){
        print("CHECKING NOTIFICATIONS")
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(){ (settings) in
            print(settings.authorizationStatus)
            if settings.authorizationStatus != .authorized || settings.alertSetting != .enabled || settings.lockScreenSetting != .enabled{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Notifications not enabled, unable to schedule set Notifications", message: nil, preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Go to settings", style: .default){(UIAlertAction) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(settingsAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                    
                    }
            }else{
                DispatchQueue.main.async {
                    handler()
                }
            }
        }
    }

}

//MARK: - SwipeTableViewController delegate methods
extension SetController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right  else { return nil }
        
        //Delete button
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletions
            //self.setArray.remove(at: indexPath.row)
            if let set = self.setArray?[indexPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(set)
                    }
                } catch{
                    print("Error deleting set")
                }
            }
            self.colorIndex = 0
            self.cardSetTableView.reloadData()
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
     /*   let renameAction = SwipeAction(style: .default, title: "Rename"){ action, indexPath in
            let alert = UIAlertController(title: "Rename Set", message: "", preferredStyle: .alert)
            var textField = UITextField()
            alert.addTextField(configurationHandler: { (alertTextField) in
                textField = alertTextField
                textField.placeholder = self.setArray![indexPath.row].title
                textField.delegate = self
            })
            self.saveAction = UIAlertAction(title: "Save", style: .default, handler: { (act) in
                if let set = self.setArray?[indexPath.row] {
                    do{
                        try self.realm.write {
                            set.title = textField.text!
                        }
                    } catch{
                        print("Error renaming set")
                    }
                }
                self.SetTableView.reloadData()
            })
            self.saveAction.isEnabled = false
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                //
            })
            alert.addAction(cancelAction)
            alert.addAction(self.saveAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        renameAction.image = UIImage(named: "rename-icon") */
        
        let setTime = SwipeAction(style: .default, title: "Settings") { (action : SwipeAction, indexPath : IndexPath) in
            self.selectedSettingCell = indexPath
            self.performSegue(withIdentifier: "OpenSetSettings", sender: self)
        }
        setTime.image = UIImage(named: "settings-icon")
        return [deleteAction, setTime]
    }
}


extension SetController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // if text length is greater than 0 enables the button, else disables it
        let existingText = textField.text as NSString?
        if let replacedText = existingText?.replacingCharacters(in: range, with: string), replacedText.count > 0 {
            saveAction.isEnabled = true
            print("Enabled")
        }
        else{
            saveAction.isEnabled = false
        }
        return true
    }
}

extension SetController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadData()
        setArray = setArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated")
        colorIndex = 0
        cardSetTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
