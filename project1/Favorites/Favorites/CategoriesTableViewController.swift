//
//  CategoriesTableViewController.swift
//  Favorites
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var categories: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var mainTableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    func initializeFetchedResultsController() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let posSort = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [posSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate? = self as NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    //With help from Ray Wenderlich
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "Add a new favorites category", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first, let catToSave = textField.text else {
                return
            }
            self.saveCat(catToSave)
            self.mainTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCat(_ catName: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Categories", in: managedObjectContext)
        let category = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        category.setValue(catName, forKey: "catName")
        category.setValue(categories.count, forKey: "position")
        
        do {
            try category.managedObjectContext?.save()
            categories.append(category)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedObjectContext = appDelegate.managedObjectContext
        //managedObjectContext = appDelegate.persistentContainer.viewContext
        
        mainTableView = self.tableView
        
        initializeFetchedResultsController()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        do {
            try categories = managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let path = indexPath {
                mainTableView.insertRows(at: [path], with: .fade)
            }
            break
        case .delete:
            if let path = indexPath {
                mainTableView.deleteRows(at: [path], with: .fade)
            }
            break
        case .update:
            if let path = indexPath {
                let cell = mainTableView.cellForRow(at: path)
                cell?.textLabel?.text = categories[path.row].value(forKey: "catName") as? String
            }
            break
        case .move:
            if let oldPath = indexPath {
                mainTableView.deleteRows(at: [oldPath], with: .fade)
            }
            if let newPath = newIndexPath {
                mainTableView.insertRows(at: [newPath], with: .fade)
            }
            break
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0//categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)

        // Configure the cell...
        //Get name of current category and set it to textLabel as String
        cell.textLabel?.text = categories[indexPath.row].value(forKey: "catName") as? String
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
            // Delete the row from the data source
            let deleteCat = fetchedResultsController.object(at: indexPath) as! NSManagedObject
            managedObjectContext.delete(deleteCat)
            categories.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        initializeFetchedResultsController()
        self.fetchedResultsController.delegate = nil
        
        let moveCat = categories[fromIndexPath.row]
        categories.remove(at: fromIndexPath.row)
        categories.insert(moveCat, at: to.row)
        
        for (i, category) in categories.enumerated() {
            category.setValue(i, forKey: "position")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.fetchedResultsController.delegate = self
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
