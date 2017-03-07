//
//  CollectionViewController.swift
//  PlantPictures
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var plantPics = ["agave", "artichoke", "aspen trees", "basil", "begonia", "chrysanthemum", "eggplant", "forsythia", "french marigold", "irises", "larkspur", "lemongrass", "lily", "maple tree", "petunia", "radish", "rosemary", "sunflower", "tulip", "viburnum", "weeping willow"]
    var globalCellSpacing = CGFloat(2)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //Find new spacing for the cells
        globalCellSpacing = findCellSpacing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantPics.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let image = UIImage(named: plantPics[indexPath.row])
        cell.imageView.image = image
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: CollectionHeadFootView?
        var footer: CollectionHeadFootView?
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionHeadFootView
            header?.headerLabel.text = "Look at all these plants!"
            return header!
        } else if kind == UICollectionElementKindSectionFooter {
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as? CollectionHeadFootView
            footer?.footerLabel.text = "Well, that's all the plants!"
            return footer!
        }
        //Return empty reusable view if something goes wrong
        return UICollectionReusableView()
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let indexPath = collectionView?.indexPath(for: sender as! UICollectionViewCell)
            let detailVC = segue.destination as! DetailViewController
            detailVC.imageName = plantPics[(indexPath?.row)!]
        }
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

}
