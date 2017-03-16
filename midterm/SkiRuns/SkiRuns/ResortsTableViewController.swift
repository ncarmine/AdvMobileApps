//
//  ResortsTableViewController.swift
//  SkiRuns
//
//  Created by Nathan Carmine on 16/3/17.
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class ResortsTableViewController: UITableViewController {
    
    var resortsList = Resorts()
    let resortsFile = "skiruns.plist"
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
        
        let path: String?
        let filePath = docFilePath(filename: resortsFile)
        
        if FileManager.default.fileExists(atPath: filePath!) {
            path = filePath
        } else {
            guard let dataPath = getDataFile(resourceName: "skiruns", type: "plist") else {
                print("Error loading file")
                return
            }
            path = dataPath
        }

        resortsList.resortsData = NSDictionary(contentsOfFile: path!) as! [String : [String]]
        resortsList.resorts = Array(resortsList.resortsData.keys)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: UIApplication.shared)
        
        //Searching
        let allItems = resortsList.resortsData.flatMap({$1})
        let resultsController = SearchTableViewController()
        resultsController.allWords = allItems
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Search Runs"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = resultsController
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        let filePath = docFilePath(filename: resortsFile)
        let data = NSMutableDictionary()
        
        data.addEntries(from: resortsList.resortsData)
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
        return resortsList.resortsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = resortsList.resorts[indexPath.row]
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
        if segue.identifier == "runsSegue" {
            let runsVC = segue.destination as! RunsTableViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            runsVC.title = resortsList.resorts[indexPath.row]
            runsVC.runsListDetail = resortsList
            runsVC.selectedRun = indexPath.row
        }
    }

}
