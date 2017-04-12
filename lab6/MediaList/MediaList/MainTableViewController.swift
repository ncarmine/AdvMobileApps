//
//  MainTableViewController.swift
//  MediaList
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//
// I AM NOT RESPONSIBLE FOR THE CONTENT ON THE PRESET WEBSITES
// Honestly I don't even visit half of them. I just know they exist.
//
// App icon / launch screen blantantly ripped from
// https://mymediastudies.files.wordpress.com/2013/03/social_media.jpg

import UIKit
import Firebase

class MainTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var media = [Media]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        ref.observe(FIRDataEventType.value, with: {snapshot in
            self.media = []
            for snapshotMedia in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let newMedia = Media(snapshot: snapshotMedia)
                self.media.append(newMedia)
            }
            self.tableView.reloadData()
        })

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)

        // Configure the cell...
        let cellMedia = media[indexPath.row]
        cell.textLabel?.text = cellMedia.category
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
        if segue.identifier == "mediaLink" {
            let subVC = segue.destination as! SubTableViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let selectedMedia = media[indexPath.row].category
            subVC.title = selectedMedia.capitalized
            subVC.currCat = selectedMedia
            subVC.ref = ref
        }
    }

}
