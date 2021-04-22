//
//  ItemTableViewController.swift
//  TO_Do_App
//
//  Created by Gaurav Aryal on 2/18/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController {
    //MARK: Properties
    
    var items = [Item]() // items = meals Item = Meal
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
           navigationItem.leftBarButtonItem = editButtonItem
                        
           if let savedItems = loadItems() {
               items += savedItems
           }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "ItemTableViewCell"
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item = items[indexPath.row] // item = meal
        cell.nameLabel.text = item.name
        cell.dateLabel.text = item.date
       
        if item.completed{
            cell.backgroundColor = UIColor.gray
            
    }
        
       else {
            cell.backgroundColor = UIColor.white
        }

       
        // Configure the cell...
        
        
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            saveItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
       else if editingStyle == .insert {
//            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view       }


    }
    }


//    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Completed") {  (action,view,completed) in
            // todo : change background coclor\
            self.items[indexPath.row].completed = true
            self.items.sort{
                !$0.completed && ($1.completed)
            }
           
            tableView.reloadData()
        }
       
        action.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [action])
        //tableView.reloadData()
           



    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {/Users/gaurav.aryal/Desktop/datepicker

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
           
           switch(segue.identifier ?? "") {
               
           case "AddItem":
               os_log("Adding a new meal.", log: OSLog.default, type: .debug)
               
           case "ShowDetail":
               guard let itemDetailViewController = segue.destination as? TableViewController else {
                   fatalError("Unexpected destination: \(segue.destination)")
               }
               
               guard let selectedItemCell = sender as? ItemTableViewCell else {
                   fatalError("Unexpected sender: \(sender)")
               }
               
               guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                   fatalError("The selected cell is not being displayed by the table")
               }
               
               let selectedItem = items[indexPath.row]
               itemDetailViewController.item = selectedItem
               
           default:
               fatalError("Unexpected Segue Identifier; \(segue.identifier)")
           }
    }
    
   // MARK: Actions
    @IBAction func unwindToItemList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? TableViewController ,   let item = sourceViewController.item {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                items.sort{
                    $0.dateobject.compare($1.dateobject) == .orderedAscending
                }
                 tableView.reloadData()
                items.sort{
                    !$0.completed && ($1.completed)
                }
                tableView.reloadData()
               
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                
                items.append(item)
                //tableView.insertRows(at: [newIndexPath], with: .automatic)
                items.sort{
                    $0.dateobject.compare($1.dateobject) == .orderedAscending
                }
                 tableView.reloadData()
                items.sort {
                    !$0.completed && ($1.completed)
                    
                }
                tableView.reloadData()
                
            }
        
            // Save the meals.
            saveItems()
           
    }

}
    
    
    private func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Items...", log: OSLog.default, type: .error)
        }
        
    }
    private func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
}
