//
//  SetControllerViewController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class SetController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    
    var setMap = [String:CardSet]()
    var setKeys = [String]()
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var SetTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetTableView.delegate = self
        SetTableView.dataSource = self
        fetchData()
        SetTableView.register(UINib(nibName: "SetCell", bundle: nil), forCellReuseIdentifier: "customSetCell")
    }
    
    func fetchData(){
        setMap = ["123":CardSet(setName: "test", setId: "123"),"345":CardSet(setName: "teset2", setId: "345")]
        setKeys = Array(setMap.keys)
    }
    
    func toggleSet(setID: String, val: Bool) {
            setMap[setID]?.isActive = val
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = SetTableView.dequeueReusableCell(withIdentifier: "customSetCell", for: indexPath) as! SetCell
        newCell.delegate = self
        newCell.title.text = setMap[setKeys[indexPath.row]]?.setName
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
