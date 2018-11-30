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
class SetController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    

    let realm = try! Realm()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    var selectedCardSet : Int = -1
    var setArray: Results<cardSet>?
    var saveAction : UIAlertAction!
    var selectedSettingCell : IndexPath?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var SetTableView: UITableView!
    
    @IBAction func sortSets(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
        searchBar.delegate = self
        SetTableView.delegate = self
        SetTableView.dataSource = self
        SetTableView.register(UINib(nibName: "SetCell", bundle: nil), forCellReuseIdentifier: "customSetCell")
        SetTableView.rowHeight = 80
    }
    
    //TOPIC: - Delegate Functions
    func toggleSet(setID: Int) {
        do{
            try realm.write {
                setArray![setID].isActive = !setArray![setID].isActive
            }
        } catch{
            print("error saving toggle")
        }
        SetTableView.reloadData()
        let set = setArray![setID]
        if set.isActive{
            appDelegate.scheduleNotifications(set: set)
        } else {
            appDelegate.cancelNotifications(set: set)
        }
        /*
        setArray[setID].isActive = val
        print("set \(setID) is \(val)")
        saveSets() */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = SetTableView.dequeueReusableCell(withIdentifier: "customSetCell", for: indexPath) as! SetCell
        newCell.selectionStyle = .none
        newCell.delegate = self
        newCell.setID = indexPath.row
        newCell.title.text = setArray?[indexPath.row].title ?? "No sets added yet"
        newCell.checkDelegate = self
        newCell.checked = setArray?[indexPath.row].isActive ?? false
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCardSet = indexPath.row
        performSegue(withIdentifier: "OpenCardsSet", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
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
        SetTableView.reloadData()
    }
    
    func loadData(){
        setArray = realm.objects(cardSet.self).sorted(byKeyPath: "dateCreated")
        SetTableView.reloadData()
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
            self.SetTableView.selectRow(at: IndexPath(row: self.setArray!.count - 1, section: 0), animated: false, scrollPosition: .top)
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
            if let indexPath = SetTableView.indexPathForSelectedRow {
                print("got it")
                dest.selectedSet = setArray?[indexPath.row]
            }
        } else if segue.identifier == "OpenSetSettings"{
            let dest = segue.destination as! SetSettingsController
            if let path = selectedSettingCell{
                dest.selectedSet = setArray?[path.row]
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
            self.SetTableView.reloadData()
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        let renameAction = SwipeAction(style: .default, title: "Rename"){ action, indexPath in
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
        
        renameAction.image = UIImage(named: "rename-icon")
        
        let setTime = SwipeAction(style: .default, title: "Timer") { (action : SwipeAction, indexPath : IndexPath) in
            self.selectedSettingCell = indexPath
            self.performSegue(withIdentifier: "OpenSetSettings", sender: self)
        }
        setTime.image = UIImage(named: "settings-icon")
        return [deleteAction, renameAction, setTime]
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
        setArray = setArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated")
        SetTableView.reloadData()
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
