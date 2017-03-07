//
//  DetailViewController.swift
//  PlantPictures
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView = UIImageView()
    var imageName: String?
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let shareScreen = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        shareScreen.modalPresentationStyle = .popover
        shareScreen.popoverPresentationController?.barButtonItem = sender as UIBarButtonItem
        present(shareScreen, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Reload constraints at runtime and remove scroll indicators
        scrollView.layoutIfNeeded()
        
        //Assign scrollview as its own delegate and title the navbar
        scrollView.delegate = self
        self.title = imageName?.capitalized
        
        //Add an imageview with the image as a subview of scrollView
        guard let detailImage = UIImage(named: self.imageName!) else {
            print("Image not loaded")
            return
        }
        //This step of having an imageView as a subview of a scrollView is what enables zooming
        imageView = UIImageView(image: detailImage)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: detailImage.size)
        scrollView.addSubview(imageView)
    }
    
    //Put the contents of the scroll view (ie, the imageView) to the center of the view
    func centerScrollViewContents() {
        let contentWidth = scrollView.contentSize.width
        let contentHeight = scrollView.contentSize.height
        let offsetX = max((scrollView.bounds.size.width - contentWidth) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - contentHeight) * 0.5, 0.0)
        imageView.center = CGPoint(x: contentWidth * 0.5 + offsetX, y: contentHeight * 0.5 + offsetY)
    }
    
    override func viewWillLayoutSubviews() {
        scrollView.layoutIfNeeded()
        scrollView.contentSize = (imageView.image?.size)!
        //Set the zoom scale so the image appears on the view properly
        let scaleWidth = scrollView.frame.width / scrollView.contentSize.width
        let scaleHeight = scrollView.frame.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        centerScrollViewContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
