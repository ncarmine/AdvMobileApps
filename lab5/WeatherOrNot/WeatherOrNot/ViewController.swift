//
//  ViewController.swift
//  WeatherOrNot
//
//  Created by Nathan Carmine 2017.
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    //Called in loadJSON when we get a URL error or fail to retrieve the file
    func failedToFetchAlert() {
        let alert = UIAlertController(title: "Failed to retrieve weather information", message: "Sorry, we couldn't get your weather information right now.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func getTemperature(_ currentWeather: JSON, _ tempType: String) -> String {
        return String(Int(currentWeather[tempType].floatValue.rounded()))+"ºF"
    }
    
    func getSummary(_ weather: JSON, _ weatherTime: String) -> String {
        return weather[weatherTime]["summary"].stringValue
    }
    
    func parseJSON(_ data: Data) {
        var error: NSError?
        let report = JSON(data: data, options: .allowFragments, error: &error)
        let currently = report["currently"]
        //Set text labels using helper functions
        tempLabel.text = getTemperature(currently, "temperature")
        feelsLabel.text?.append(getTemperature(currently, "apparentTemperature"))
        summaryLabel.text = getSummary(report, "currently")
        hourLabel.text = getSummary(report, "minutely")
        todayLabel.text = getSummary(report, "hourly")
        weekLabel.text = getSummary(report, "daily")
        //Set labels to top align
        hourLabel.sizeToFit()
        todayLabel.sizeToFit()
        weekLabel.sizeToFit()
    }
    
    func loadJSON(urlPath: String) {
        guard let url = URL(string: urlPath) else {
            print("url error")
            failedToFetchAlert()
            return
        }
        let session = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            guard statusCode == 200
                else {
                    print("file download error")
                    self.failedToFetchAlert()
                    return
            }
            //parse JSON on successful download
            DispatchQueue.main.async {self.parseJSON(data!)}
        })
        //resume to run session
        session.resume()
    }
    
    func getDarkSkyData() {
        let coordinates = locationManager.location?.coordinate
        if coordinates != nil {
            loadJSON(urlPath: "https://api.darksky.net/forecast/251044d8d01971a3d739a13ddd102c08/"+String(coordinates!.latitude)+","+String(coordinates!.longitude))
            
            /* FOR TESTING PURPOSES */
//            let report = JSONInfo().json!
//            let currently = report["currently"]
//            tempLabel.text = getTemperature(currently, "temperature")
//            feelsLabel.text?.append(getTemperature(currently, "apparentTemperature"))
//            summaryLabel.text = getSummary(report, "currently")
//            hourLabel.text = getSummary(report, "minutely")
//            todayLabel.text = getSummary(report, "hourly")
//            weekLabel.text = getSummary(report, "daily")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        
        

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            //request permission when in use
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            //Alert user they need to enable location services to use app
            let alert = UIAlertController(title: "Location Services Disabled", message: "Enable location services in Settings to get your local weather", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
                if (UIApplication.shared.canOpenURL(URL(string: UIApplicationOpenSettingsURLString)!)) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
            present(alert, animated: true, completion: nil)
        default:
            //The following if statement and other CLLocationManager methods handle when we do have access
            break
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer //km is appropriate accuracy
            locationManager.requestLocation() //request an initial location. gets stored in locationManager
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         return
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Get all the data (and then parse and display it) when we have access
        if status == .authorizedWhenInUse {
            getDarkSkyData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager failed with error", error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

