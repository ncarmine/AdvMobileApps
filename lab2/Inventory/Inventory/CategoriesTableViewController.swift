//
//  CategoriesTableViewController.swift
//  Inventory
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var inventory = Inventory()
    let inventoryFile = "inventory.plist"
    var categories = [String: [String: NSNumber]]()
    var items = [String: NSNumber]()
    var searchController: UISearchController!
    
    func getDataFile(resourceName: String, type: String) -> String? {
        guard let pathString = Bundle.main.path(forResource: resourceName, ofType: type) else {
            return nil
        }
        return pathString
    }
    
    func docFilePath(filename: String) -> String? {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = path[0] as NSString
        return dir.appendingPathComponent(filename)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let path: String?
        let filePath = docFilePath(filename: inventoryFile)
        
        if FileManager.default.fileExists(atPath: filePath!) {
            path = filePath
        } else {
            guard let dataPath = getDataFile(resourceName: "inventory", type: "plist") else {
                print("Error loading file")
                return
            }
            path = dataPath
        }
        
        inventory.categoriesDict = NSDictionary(contentsOfFile: path!) as! [String : [String: NSNumber]]
        inventory.categoryNames = Array(inventory.categoriesDict.keys)
        
        //Set up event listener for willResignActive
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        
        // flatMap "flattens" all items in a dict into an array of tuples
        // {$1} gets all the inner dictionaries
        // These then get converted into another dictionary of just items (no categories)
        let allItems = inventory.categoriesDict.flatMap({$1})
        var allItemsDict = [String: NSNumber]()
        allItems.forEach{name, amount in allItemsDict[name] = amount}
        
        let resultsController = SearchTableViewController()
        resultsController.allWords = allItemsDict
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Find an item"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = resultsController
    }
    
    func applicationWillResignActive() {
        let filePath = docFilePath(filename: inventoryFile)
        let data = NSMutableDictionary()
        
        data.addEntries(from: inventory.categoriesDict)
        data.write(toFile: filePath!, atomically: true)
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
        return inventory.categoryNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        cell.textLabel?.text = inventory.categoryNames[indexPath.row]
        return cell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemSegue" {
            let itemVC = segue.destination as! ItemsTableViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            itemVC.title = inventory.categoryNames[indexPath.row]
            itemVC.inventory = inventory
            itemVC.selectedCategory = indexPath.row
        }
    }

}
