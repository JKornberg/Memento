//
//  SetControllerViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
import SwipeCellKit

class SetController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    

    

    @IBOutlet weak var sortButton: UIButton!
    var setMap : [CardSet] = [CardSet]()
    var selectedCardSet : Int = -1
    var saveAction : UIAlertAction!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("CardSets.plist")
    
    @IBOutlet weak var SetTableView: UITableView!
    
    @IBAction func sortSets(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dataFilePath)
        fetchData()
        SetTableView.delegate = self
        SetTableView.dataSource = self
        SetTableView.register(UINib(nibName: "SetCell", bundle: nil), forCellReuseIdentifier: "customSetCell")
        SetTableView.rowHeight = 80
    }
    
    //TOPIC: - Delegate Functions
    func toggleSet(setID: Int, val: Bool) {
        setMap[setID].isActive = val
        print("set \(setID) is \(val)")
        saveSets()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = SetTableView.dequeueReusableCell(withIdentifier: "customSetCell", for: indexPath) as! SetCell
        newCell.delegate = self
        newCell.setID = indexPath.row
        newCell.title.text = setMap[indexPath.row].setName
        newCell.checkDelegate = self
        newCell.checkView.checked = setMap[indexPath.row].isActive
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCardSet = indexPath.row
        performSegue(withIdentifier: "OpenCardsSet", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //TOPIC: Manage Data
    func saveSets(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.setMap)
            try data.write(to: self.dataFilePath! )
            print("saving")
            
        }
        catch{
            print("error encoding")
        }
    }
    
    func fetchData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                setMap = try decoder.decode([CardSet].self, from: data)
            }
            catch{
                print("Error loading data: \(error)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        selectedCardSet = -1
        performSegue(withIdentifier: "OpenCardsSet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCardsSet"{
            let dest = segue.destination as! CardsController
            dest.delegate = self
            if selectedCardSet != -1{
                dest.cards = setMap[selectedCardSet].cards
                dest.setName = setMap[selectedCardSet].setName
            }
            else {
                dest.cards = [Card(side1: "", side2: "", cardId: 0)]
            }
            dest.setId = selectedCardSet

            
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
        guard orientation == .right else { return nil }
        
        //Delete button
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletions
            self.setMap.remove(at: indexPath.row)
            self.saveSets()
            self.fetchData()
            self.SetTableView.reloadData()
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        let renameAction = SwipeAction(style: .default, title: "Rename"){ action, indexPath in
            let alert = UIAlertController(title: "Rename Set", message: "", preferredStyle: .alert)
            var textField = UITextField()
            alert.addTextField(configurationHandler: { (alertTextField) in
                textField = alertTextField
                textField.placeholder = self.setMap[indexPath.row].setName
                textField.delegate = self
            })
            self.saveAction = UIAlertAction(title: "Save", style: .default, handler: { (act) in
                self.setMap[indexPath.row].setName = textField.text!
                self.saveSets()
                self.fetchData()
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
        
        return [deleteAction, renameAction]
    }
}

//Mark: - CardsController Delegate Methods (Saving cards)
extension SetController : CardsControllerDelegate{
    func createAndSaveCards(title: String, cards: [Card]) {
        let newCardSet = CardSet(setName: title, cards: cards)
        print(title)
        setMap.append(newCardSet)
        SetTableView.reloadData()
        saveSets()
    }
    
    func saveCards(cards: [Card], setId: Int?){
        setMap[setId!].cards = cards
        saveSets()
    }
    
    func removeCard(indexPath: IndexPath, setId: Int?){
        saveSets()
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
