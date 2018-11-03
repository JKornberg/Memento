//
//  SetControllerViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class SetController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    @IBAction func addSet(_ sender: Any) {
    }
    
    @IBOutlet weak var sortButton: UIButton!
    var setMap = [Int:CardSet]()
    var setKeys = [Int]()
    @IBOutlet weak var SetTableView: UITableView!
    @IBAction func sortSets(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetTableView.delegate = self
        SetTableView.dataSource = self
        fetchData()
        SetTableView.register(UINib(nibName: "SetCell", bundle: nil), forCellReuseIdentifier: "customSetCell")
    }
    
    func fetchData(){
        setMap = [1:CardSet(setName: "test", setId: 1),2:CardSet(setName: "teset2", setId: 2)]
        setKeys = Array(setMap.keys)
    }
    
    func toggleSet(setID: Int, val: Bool) {
            setMap[setID]?.isActive = val
            print("set \(setID) is \(val)")
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = SetTableView.dequeueReusableCell(withIdentifier: "customSetCell", for: indexPath) as! SetCell
        newCell.delegate = self
        newCell.setID = setMap[setKeys[indexPath.row]]!.setId
        newCell.title.text = setMap[setKeys[indexPath.row]]?.setName
        newCell.checkView.checked = setMap[setKeys[indexPath.row]]!.isActive
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath)")
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
