//
//  CurrentWeatherViewController.swift
//  API Demo
//
//  Created by Aaron Elijah on 19/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    var stringCity : String = ""
    
    var originalTextInput : String = ""
    
    var messageText : String = ""
    
    var fromGoogleMaps : Bool = false
    
    var latitudeGiven : CLLocationDegrees!
    
    var longitudeGiven : CLLocationDegrees!
    
    @IBOutlet var tempUnits: UISwitch!
    
    @IBAction func tempUnitsChanged(_ sender: Any) {
        
        if let temperature : Float = Float(temperatureLabel.text!) {
            
            if tempUnits.isOn == false {
                // convert celcius to farenheit
                
                let tempFarenheit = Float((temperature * 1.8) + 32.0)
                
                temperatureLabel.text = String(tempFarenheit)
                
            } else if tempUnits.isOn == true {
                // convert farenheit to celcius
                
                let tempCelcius = Float((temperature - 32.0) / 1.8)
                
                temperatureLabel.text = String(tempCelcius)
            }
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var pressureLabel: UILabel!
    
    @IBOutlet var humidityLabel: UILabel!
    
    @IBOutlet var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
        
        updateValues()
        
        // temperature is in Celcius
        if Float(self.temperatureLabel.text!) != nil {
            
            if Float(self.humidityLabel.text!) != nil {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    if Float(self.temperatureLabel.text!)! > 30.0 && Float(self.humidityLabel.text!)! > 90.0 {
                        self.messageText = "Very Hot and Humid weather today"
                
                    } else if Float(self.temperatureLabel.text!)! < 5.0 && Float(self.humidityLabel.text!)! > 90.0 {
                        self.messageText = "Very Cold and Humid weather woday"
                
                    } else if Float(self.temperatureLabel.text!)! > 30.0 && Float(self.humidityLabel.text!)! < 40.0 {
                        self.messageText = "Very Hot and Dry weather today"
                
                    } else if Float(self.temperatureLabel.text!)! < 5.0 && Float(self.humidityLabel.text!)! < 40.0 {
                        self.messageText = "Very Cold and Dry weather today"
                
                    } else if Float(self.temperatureLabel.text!)! > 30.0 {
                        self.messageText = "Very Hot weather today"
                
                    } else if Float(self.temperatureLabel.text!)! < 5.0 {
                        self.messageText = "Very Cold weather today"
                
                    } else if Float(self.humidityLabel.text!)! < 40.0 {
                        self.messageText = "Very Dry weather today"
                
                    } else if Float(self.humidityLabel.text!)! > 90.0 {
                        self.messageText = "Very Humid weather today"
                    }
        
                    if self.messageText != "" {
                        self.createAlert(title: "Warning!", message: self.messageText)
                    }
                })
            }
        }
    }
    
    func updateValues() {
        
        // add the activity indicator for temperature
        let tempActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempActivityIndicator.center = temperatureLabel.center
        tempActivityIndicator.hidesWhenStopped = true
        tempActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(tempActivityIndicator)
        tempActivityIndicator.startAnimating()
        
        // add the activity indicator for description
        let desActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        desActivityIndicator.center = descriptionLabel.center
        desActivityIndicator.hidesWhenStopped = true
        desActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(desActivityIndicator)
        desActivityIndicator.startAnimating()
        
        // add the activity indicator for humidity
        let humActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        humActivityIndicator.center = humidityLabel.center
        humActivityIndicator.hidesWhenStopped = true
        humActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(humActivityIndicator)
        humActivityIndicator.startAnimating()
        
        // add the activity indicator for pressure
        let preActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        preActivityIndicator.center = pressureLabel.center
        preActivityIndicator.hidesWhenStopped = true
        preActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(preActivityIndicator)
        preActivityIndicator.startAnimating()
        
        var urlString : String = ""
        
        // var temperature : Int?
        
        if fromGoogleMaps == false {
            let city = NSString(string: originalTextInput)
        
            if city.contains(" ") {
                stringCity = city.replacingOccurrences(of: " ", with: "%20")
            } else {
                stringCity = originalTextInput
            }
        
            
            urlString = ("http://api.openweathermap.org/data/2.5/weather?q=" + stringCity + "&appid=6ca1ae2dc9adc508f7b6712077e61fc2")
            
        } else if fromGoogleMaps == true {
            
            urlString = ("http://api.openweathermap.org/data/2.5/weather?lat=" + String(latitudeGiven) + "&lon=" + String(longitudeGiven) + "&appid=6ca1ae2dc9adc508f7b6712077e61fc2")
        }
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
                tempActivityIndicator.stopAnimating()
                self.temperatureLabel.text = "This city may not exist or there is an error trying to fetch the data for it"
                
            } else {
                // urlContent is going to be JSON
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print(jsonResult)
                        
                        var text : String = ""
                        
                        
                        // DispatchQueue inorder to not have to wait
                        // we want to dispatch the main Queue
                        DispatchQueue.main.sync(execute:  {
                            
                            if let temporaryTemperature = (jsonResult["main"] as? NSDictionary)?["temp"] as? Int {
                                
                                tempActivityIndicator.stopAnimating()
                                
                                let tempCelcius = temporaryTemperature - 273
                                text += "\(Double(tempCelcius))"
                                
                                if text != "" {
                                    self.temperatureLabel.text = text
                                } else {
                                    self.temperatureLabel.text = "That city is not found"
                                }
                            }
                            
                            if let temporaryHumidity = (jsonResult["main"] as? NSDictionary)?["humidity"] as? Int {
                                
                                humActivityIndicator.stopAnimating()
                                
                                let humidity = String(temporaryHumidity)
                                
                                self.humidityLabel.text = humidity
                            }
                            
                            if let temporaryPressure = (jsonResult["main"] as? NSDictionary)?["pressure"] as? Int {
                                
                                preActivityIndicator.stopAnimating()
                                
                                let pressure = String(temporaryPressure)
                                
                                self.pressureLabel.text = pressure
                            }
                            
                            if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                
                                desActivityIndicator.stopAnimating()
                                
                                self.descriptionLabel.text = description
                            }
                            
                            if let name = (jsonResult["name"] as? String) {
                                
                                self.navigationItem.title = name
                            }
                            
                            if let iconId = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["icon"] as? String {
                                
                                let url = URL(string: "http://openweathermap.org/img/w/" + iconId + ".png")
                                
                                if let data = NSData(contentsOf: url!) {
                                    
                                    if let downloadedImage = UIImage(data: data as Data) {
                                    
                                        self.iconView.image = downloadedImage
                                    }
                                }
                            }
                            
                            if self.fromGoogleMaps == false {
                                self.latitudeGiven = (jsonResult["coord"] as? NSDictionary)?["lat"] as? CLLocationDegrees
                                self.longitudeGiven = (jsonResult["coord"] as? NSDictionary)?["lon"] as? CLLocationDegrees
                            }
                            
                        })
                        
                    } catch {
                            
                        self.temperatureLabel.text = "Problem trying to process JSON data from API"
                        
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    @IBAction func gotToWeekForecast(_ sender: Any) {
        
        performSegue(withIdentifier: "CurrentToWeek", sender: self)
        
    }
    
    @IBAction func goToGoogleMaps(_ sender: Any) {
        
        performSegue(withIdentifier: "CurrentToGoogleMaps", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentToWeek" {
            
            let controller = (segue.destination) as! WeekForecastViewController
            
            if fromGoogleMaps == false {
                controller.stringCity = stringCity
                controller.originalTextInput = originalTextInput
                controller.fromGoogleMaps = fromGoogleMaps      // false
                
            } else if fromGoogleMaps == true {
                controller.latitudeGiven = latitudeGiven
                controller.longitudeGiven = longitudeGiven
                controller.fromGoogleMaps = fromGoogleMaps      // true
                
            }
        } else if segue.identifier == "CurrentToGoogleMaps" {
            
            let controller = (segue.destination) as! OtherViewController
            
            controller.latitudeGiven = latitudeGiven
            controller.longitudeGiven = longitudeGiven
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            
            // self.dismiss will dismiss the PostViewController so it dismisses that instead
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
