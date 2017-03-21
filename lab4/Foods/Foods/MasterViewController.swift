//
//  MasterViewController.swift
//  Foods
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var foodTypes = [String]()
    var foods = [String : [String]]()

    func getDataFile(resourceName: String, type: String) -> String? {
        guard let pathString = Bundle.main.path(forResource: resourceName, ofType: type) else {
            return nil
        }
        return pathString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        guard let dataPath = getDataFile(resourceName: "foods", type: "plist") else {
            print("Error loading file")
            return
        }
        
        self.title = "Food Types"
        
        let wholeFoods = NSDictionary(contentsOfFile: dataPath) as! [String: [String]]
        if !wholeFoods.isEmpty {
            foodTypes = Array(wholeFoods.keys.sorted())
            foods = wholeFoods //This lab is sponsored by Sprouts
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let food = foodTypes[indexPath.row]
        cell.textLabel!.text = food
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let foodType = foodTypes[indexPath.row]
                let selectedFoods = self.foods[foodType]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.title = foodType
                controller.detailItems = selectedFoods
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}

