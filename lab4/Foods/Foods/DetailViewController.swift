//
//  DetailViewController.swift
//  Foods
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//
// Most images taken from http://www.bhg.com/ and https://a-z-animals.com/
// All others from image searches

import UIKit

private let reuseIdentifier = "reuseCell"

class DetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var globalCellSpacing = CGFloat(2)
    var detailItems: [String]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func addNoImageLabel() {
        let noImageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        noImageLabel.center = collectionView!.center
        noImageLabel.textAlignment = .center
        noImageLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        noImageLabel.text = "Please select a food type on the left"
        noImageLabel.font = UIFont(name: "Helvetica", size: 18)
        view.addSubview(noImageLabel)
    }

    func configureView() {
        // Update the user interface for the detail item.
        //Find new spacing for the cells
        globalCellSpacing = findCellSpacing()
        guard let items = detailItems else {
            addNoImageLabel()
            return
        }
        if items.count <= 0 {
            addNoImageLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        self.configureView()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let detailItemsCount = detailItems?.count else {
            return 0
        }
        return detailItemsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DetailViewCell
        
        // Configure the cell
        guard let image = UIImage(named: detailItems![indexPath.row]) else {
            return cell
        }
        cell.imageView.image = image
        
        return cell
    }
    
    func findItemsPerRow(_ screenWidth: CGFloat) -> CGFloat {
        //iPhone 5, 5s, SE
        if screenWidth < 600 {
            return floor(screenWidth/100)
            //iPads in landscape
        } else if screenWidth > 1000 {
            return ceil(screenWidth/150)
            //All other iPhones, and iPads in portrait
        } else {
            return round(screenWidth/125)
        }
    }
    
    func findCellSpacing() -> CGFloat {
        let screenWidth = collectionView!.bounds.size.width
        let numColumns = findItemsPerRow(screenWidth)
        var cellSpacing = 2 //minimum cell spacing
        
        //Ensure the cell spacing is an integer
        //Horizontal spacing gets messy with non-ints
        while (screenWidth - (CGFloat(cellSpacing) * (numColumns-1))).truncatingRemainder(dividingBy:  numColumns) != 0 {
            cellSpacing += 1
        }
        
        return CGFloat(cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.size.width
        let numColumns = findItemsPerRow(screenWidth)
        let cellSpacing = globalCellSpacing
        
        let totalSpace = CGFloat(cellSpacing) * (numColumns-1)
        let cellSize = (screenWidth - totalSpace) / numColumns
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return globalCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return globalCellSpacing
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
        globalCellSpacing = findCellSpacing()
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let indexPath = collectionView?.indexPath(for: sender as! UICollectionViewCell)
            let detailVC = segue.destination as! FullImageViewController
            detailVC.imageName = detailItems?[(indexPath?.row)!]
        }
    }

}

