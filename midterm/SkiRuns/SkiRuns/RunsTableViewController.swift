//
//  RunsTableViewController.swift
//  SkiRuns
//
//  Created by Nathan Carmine on 16/3/17.
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class RunsTableViewController: UITableViewController {
    
    var runs = [String]()
    var runsListDetail = Resorts()
    var selectedRun = 0
    
    @IBAction func addRun(_ sender: UIBarButtonItem) {
        //Using an alert for this so I don't have to mess with autolayout ;-)
        //Also it's maybe a cleaner solution than a separate VC
        let alert = UIAlertController(title: "Add Run", message: "Add a new run", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            let newRun = alert.textFields?.first?.text
            if !(newRun?.isEmpty)! {
                self.runs.append(newRun!)
                self.tableView.reloadData()
                let chosenRun = self.runsListDetail.resorts[self.selectedRun]
                self.runsListDetail.resortsData[chosenRun]?.append(newRun!)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        runsListDetail.resorts = Array(runsListDetail.resortsData.keys)
        let chosenRun = runsListDetail.resorts[selectedRun]
        runs = runsListDetail.resortsData[chosenRun]! as [String]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return runs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = runs[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            runs.remove(at: indexPath.row)
            let chosenRun = runsListDetail.resorts[selectedRun]
            runsListDetail.resortsData[chosenRun]?.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
