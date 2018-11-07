//
//  CardsController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/25/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
protocol CardsControllerDelegate{
    func createAndSaveCards(title: String, cards: [Card])
    func saveCards(cards: [Card], setId: Int?)
}

class CardsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    var cards : [Card] = [Card]()
    var setName : String?
    var setId : Int?
    var saveAction : UIAlertAction!
    @IBOutlet weak var tableView: UITableView!
    var delegate : CardsControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func addCard(_ barItem: UIBarButtonItem){
        refreshArray()
        cards.append(Card(side1: "", side2: "", cardId: cards.count))
        tableView.reloadData()
    }
    
    func refreshArray()
    {
        for (index, card) in cards.enumerated(){
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! CardCell
            if let text = cell.side1.text {
                card.side1 = text
            }
            if let text = cell.side2.text {
                card.side2 = text
            }
        }
    }
    
    @IBAction func donePressed(_ barItem: UIBarButtonItem)
    {
        refreshArray()
        if setId != -1{
            self.delegate?.saveCards(cards: self.cards, setId: setId)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            var textField = UITextField()
            textField.delegate = self
            let alert  = UIAlertController(title: "Would you like to save this set of cards?", message: "", preferredStyle: .alert)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Enter set name"
                textField = alertTextField
                textField.delegate = self
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            
            //Set up Save Button and add to alert
            saveAction = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
               // textField.layer.borderColor = UIColor.red.cgColor
                self.delegate?.createAndSaveCards(title: textField.text!, cards: self.cards)
                self.navigationController?.popViewController(animated: true)
            }
            saveAction.isEnabled = false
            alert.addAction(cancelAction)
            alert.addAction(saveAction)

            present(alert, animated: true, completion: nil)
        }
    }
    // Textfield delegate method for observing the text change
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    return cards.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCardCell", for: indexPath) as! CardCell
        cell.side1.text = cards[indexPath.row].side1
        cell.side2.text = cards[indexPath.row].side2
        createShadow(cell: cell)
        cell.selectionStyle = .none
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
        print(cell.layer.bounds.width-40)
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

}
