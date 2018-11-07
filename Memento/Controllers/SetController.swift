//
//  SetControllerViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class SetController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate, CardsControllerDelegate {

    

    @IBOutlet weak var sortButton: UIButton!
    var setMap : [CardSet] = [CardSet]()
    var selectedCardSet : Int = -1
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
    }
    
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
        newCell.checkView.checked = setMap[indexPath.row].isActive
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCardSet = indexPath.row
        performSegue(withIdentifier: "OpenCardsSet", sender: self)
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
