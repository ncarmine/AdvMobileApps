//
//  SubTableViewController.swift
//  MediaList
//
//  Created by Nathan Carmine on 11/4/17.
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit
import Firebase

class SubTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var currCat = String()
    var links = [String: String]()
    var linkNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Firebase observer
        ref.child(currCat).observe(.value, with: {snapshot in
            self.links = [String: String]()
            for link in snapshot.children.allObjects as! [FIRDataSnapshot]{
                self.links[link.key] = link.value as? String
            }
            self.linkNames = Array(self.links.keys.sorted())
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = linkNames[indexPath.row]
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
            let deleteLink = linkNames[indexPath.row]
            let linkRef = ref.child(currCat).child(deleteLink)
            linkRef.ref.removeValue()
        }    
    }

    // MARK: - Navigation
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "savegue" {
            let source = segue.source as! AddItemViewController
            let newName = source.addedName
            let newURL = source.addedURL
            if !newName.isEmpty && !newURL.isEmpty {
                links[newName] = newURL
                ref.child(currCat).child(newName).setValue(newURL)
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showeb" {
            let detailVC = segue.destination as! WebViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let segueLinkName = linkNames[indexPath.row]
            //sets the data for the destination controller
            detailVC.title = segueLinkName
            detailVC.webPage = links[segueLinkName]
        }
    }

}
