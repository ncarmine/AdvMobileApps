//
//  WebViewController.swift
//  Linked List
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webVIew: UIWebView!
    @IBOutlet weak var webSpinner: UIActivityIndicatorView!
    
    var webPage: String?
    
    func shareButton() {
        let shareScreen = UIActivityViewController(activityItems: [webPage!], applicationActivities: nil)
        shareScreen.modalPresentationStyle = .popover
        present(shareScreen, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webVIew.delegate = self
        loadWebPage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButton))
    }
    
    func loadWebPage() {
        guard let strURL = webPage else {
            print("Web page not found")
            return
        }
        let url = URL(string: strURL)
        let request = URLRequest(url: url!)
        webVIew.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        webSpinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webSpinner.stopAnimating()
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
