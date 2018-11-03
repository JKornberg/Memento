//
//  CardsController.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/25/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class CardsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate  {
    var cards = [Card]()
    var cardKeys = [Int]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        cards.append(Card(side1: "", side2: "", cardId: 0))
        tableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "customCardCell")
        initToolbar()
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
        cards.append(Card(side1: "", side2: "", cardId: cards.count))
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
        createShadow(cardView: cell.cardView)
      //  cell.side1.delegate=self
        //cell.side2.delegate=self
        // Configure the cell...
        return cell
    }
    
    func createShadow(cardView: UIView){
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.6
        let shadowPath = CGPath(rect: CGRect(x: 10,
                                             y:  8,
                                             width: cardView.layer.bounds.width,
                                             height: cardView.layer.bounds.height), transform: nil)
        
        cardView.layer.shadowPath = shadowPath
        print(cardView.layer.bounds.width)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{
            (constraint) in
            if constraint.firstAttribute == .height{
                constraint.constant = estimatedSize.height
            }
        }
        configureTableView()
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
