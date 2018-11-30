//
//  CardsController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/25/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class CardsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    let realm = try! Realm()
    var cardArray : List<Card>?
    var changedCards = [IndexPath]()
    var saveAction : UIAlertAction!
    @IBOutlet weak var tableView: UITableView!
    var selectedSet : cardSet? {
        didSet{
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name.myNotificationKey, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveTerminate(_:)), name: Notification.Name.terminationNotificationKey, object: nil)
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "customCardCell")
        initToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePressed(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        configureTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func initToolbar(){
        let bar = UIToolbar()
        self.view.addSubview(bar)

        bar.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive=true
        self.view.leadingAnchor.constraint(equalTo: bar.leadingAnchor).isActive=true
        self.view.trailingAnchor.constraint(equalTo: bar.trailingAnchor).isActive=true
        self.view.bottomAnchor.constraint(equalTo: bar.bottomAnchor).isActive=true
        
        bar.backgroundColor = UIColor.black
        bar.translatesAutoresizingMaskIntoConstraints = false
        let addCardButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addCard(_:)))
        addCardButton.tag = 1
        addCardButton.style = .plain
        bar.setItems([addCardButton], animated: true)
    }
    
    func configureTableView(){
        tableView.rowHeight = 200
    }
    @objc func didReceiveTerminate(_ notification : Notification){
        saveCards()
    }
    
    @IBAction func addCard(_ barItem: UIBarButtonItem){
        saveCards()
        do{
            try realm.write{
                let newCard = Card()
                newCard.side1 = ""
                newCard.side2 = ""
                selectedSet?.cards.append(newCard)
                tableView.reloadData()
            }
        } catch{
            print("Error adding card: \(error)")
        }
    }
    
    func loadData(){
        cardArray = selectedSet?.cards
        if cardArray?.count == 0 {
            //set is empty
            do{
                try realm.write{
                    let newCard = Card()
                    newCard.side1 = ""
                    newCard.side2 = ""
                    selectedSet?.cards.append(newCard)
                    print("here")
                }
            } catch{
                print("Error adding card: \(error)")
            }
        }
    }
    
    func saveCards(){
        for path in changedCards{
            if let card = cardArray?[path.row]{
                do{
                    try realm.write{
                        let cell = tableView.cellForRow(at: path) as! CardCell
                        card.side1 = cell.side1.text ?? ""
                        card.side2 = cell.side2.text ?? ""
                    }
                } catch{
                    print("Error saving cards: \(error)")
                }
            }
        }
        changedCards = []
    }

    
    @IBAction func donePressed(_ barItem: UIBarButtonItem)
    {
        saveCards()
        navigationController?.popViewController(animated: true)
    }
    // Textfield delegate method for observing the text change
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // if text length is greater than 0 enables the button, else disables it
        if textField.tag == 2 {
            let existingText = textField.text as NSString?
            if let replacedText = existingText?.replacingCharacters(in: range, with: string), replacedText.count > 0 {
                saveAction.isEnabled = true
            }
            else{
                saveAction.isEnabled = false    
            }
        }
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardArray?.count ?? 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCardCell", for: indexPath) as! CardCell
        if let card = cardArray?[indexPath.row]{
            cell.side1.text = card.side1
            cell.side2.text = card.side2
        }
        else{
            cell.side1.text = ""
            cell.side2.text = ""
        }

        cell.delegate = self
        cell.cardDelegate = self
        createShadow(cell: cell)
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        //cell.side1.delegate=self
        //cell.side2.delegate=self
        // Configure the cell...
        return cell
    }
    
    func createShadow(cell: CardCell){
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        cell.cardView.layer.shadowOpacity = 0.6
        let shadowPath = CGPath(rect: CGRect(x: 0,
                                             y:  5,
                                             width: cell.cardView.bounds.width,
                                             height: cell.cardView.layer.bounds.height), transform: nil)
        
        cell.cardView.layer.shadowPath = shadowPath
    }
    
}


extension Notification.Name{
    public static let terminationNotificationKey = Notification.Name(rawValue: "terminationNotificationKey")
}

extension CardsController : CardCellDelegate{
    func appendToChanged(indexPath: IndexPath) {
        changedCards.append(indexPath)
    }
}


extension CardsController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        //Delete button
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletions
            //self.cardArray.remove(at: indexPath.row)
            self.saveCards()
            if let card = self.cardArray?[indexPath.row]{
                do {
                    try self.realm.write{
                        self.realm.delete(card)
                    }
                } catch {
                    print("Error deleting card")
                }
            }

            self.tableView.reloadData()
         }
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    
}

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


