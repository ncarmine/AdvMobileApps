//
//  ItemsTableViewController.swift
//  Inventory
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var items = [String: NSNumber]()
    var itemNames = [String]()
    var inventory = Inventory()
    var selectedCategory = 0
    var chosenCategory = String.init()
    
    override func viewWillAppear(_ animated: Bool) {
        inventory.categoryNames = Array(inventory.categoriesDict.keys)
        chosenCategory = inventory.categoryNames[selectedCategory]
        items = inventory.categoriesDict[chosenCategory]! as [String: NSNumber]
        itemNames = Array(items.keys).sorted()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        let itemName = itemNames[indexPath.row]
        cell.textLabel?.text = itemName
        cell.detailTextLabel?.text = String(describing: items[itemName]!)
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeItem = itemNames[indexPath.row]
            // Remove item from arrays
            itemNames.remove(at: indexPath.row)
            items.removeValue(forKey: removeItem)
            // Delete the item from the inventory
            inventory.categoriesDict[chosenCategory]!.removeValue(forKey: removeItem)
            // Delete row from table
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*** Rearranging not supported due to all data structures being dictionaries ***/

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToModify" {
            let navVC = segue.destination as! UINavigationController
            let modifyVC = navVC.viewControllers.first as! ModifyItemViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            modifyVC.name = itemNames[indexPath.row]
            modifyVC.oldAmount = items[itemNames[indexPath.row]]!
            print("modify")
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        if segue.identifier == "addSegue" {
            let addVC = segue.source as! AddItemViewController
            if !(addVC.addedItem?.name.isEmpty)! && addVC.addedItem?.amount != nil {
                let addIt = addVC.addedItem!
                itemNames.append(addIt.name)
                items[addIt.name] = addIt.amount
                tableView.reloadData()
                inventory.categoriesDict[chosenCategory]?[addIt.name] = addIt.amount
                
            }
        } else if segue.identifier == "modifySegue" {
            let modifyVC = segue.source as! ModifyItemViewController
            if modifyVC.newAmount != nil {
                items[modifyVC.name] = modifyVC.newAmount
                inventory.categoriesDict[chosenCategory]?[modifyVC.name] = modifyVC.newAmount
                tableView.reloadData()
            }
        }
    }

}
