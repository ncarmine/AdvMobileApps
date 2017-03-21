//
//  FullImageViewController.swift
//  Foods
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        if let name = imageName {
            imageView.image = UIImage(named: name)
            self.title = name.capitalized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
