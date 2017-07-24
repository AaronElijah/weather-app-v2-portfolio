//
//  WeekForecastViewController.swift
//  API Demo
//
//  Created by Aaron Elijah on 19/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class WeekForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var stringCity : String = ""
    
    var originalTextInput : String = ""
    
    var timeArray : [String] = [String]()
    var tempArray : [Int] = [Int]()
    var descriptionArray : [String] = [String]()
    
    var latitudeGiven : CLLocationDegrees!
    var longitudeGiven : CLLocationDegrees!
    
    var fromGoogleMaps : Bool = false
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backgroundImage = UIImage(named: "kalen-emsley-100238.jpg")
        let imageView = UIImageView(image: backgroundImage)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        
        
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        
        let city = NSString(string: originalTextInput)
        
        if city.contains(" ") {
            stringCity = city.replacingOccurrences(of: " ", with: "%20")
        } else {
            stringCity = originalTextInput
        }
        
        var urlString : String = ""
        
        if fromGoogleMaps == false {
            let city = NSString(string: originalTextInput)
            
            if city.contains(" ") {
                stringCity = city.replacingOccurrences(of: " ", with: "%20")
            } else {
                stringCity = originalTextInput
            }
            
            
            urlString = ("http://api.openweathermap.org/data/2.5/forecast?q=" + stringCity + "&appid=6ca1ae2dc9adc508f7b6712077e61fc2")
            
        } else if fromGoogleMaps == true {
            
            urlString = ("http://api.openweathermap.org/data/2.5/forecast?lat=" + String(latitudeGiven) + "&lon=" + String(longitudeGiven) + "&appid=6ca1ae2dc9adc508f7b6712077e61fc2")
        }
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
                print("This city may not exist or there is an error trying to fetch the data for it")
                
            } else {
                
                // urlContent is going to be JSON
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        DispatchQueue.main.sync(execute: {
                            
                            if let tempList = (jsonResult["list"] as? NSArray) {
                                // print(tempList)
                                
                                for item in tempList {
                                    
                                    // print(item)
                                    
                                    if let dictionary = item as? NSDictionary {
                                        
                                        if let date = dictionary["dt_txt"] as? String {
                                        
                                            self.timeArray.append(date)
                                        }
                                        
                                        if let temperature = ((dictionary["main"] as? NSDictionary)?["temp"] as? Int) {
                                            
                                            let tempCelcius = temperature - 273
                                            
                                            self.tempArray.append(tempCelcius)
                                        }
                                        
                                        if let description = ((dictionary["weather"] as? NSArray)?[0]  as? NSDictionary)?["description"] as? String {
                                            
                                            self.descriptionArray.append(description)
                                        }
                                        
                                        if self.fromGoogleMaps == false {
                                            self.latitudeGiven = ((jsonResult["city"] as? NSDictionary)?["coord"] as? NSDictionary)?["lat"] as? CLLocationDegrees
                                            self.longitudeGiven = ((jsonResult["city"] as? NSDictionary)?["coord"] as? NSDictionary)?["lon"] as? CLLocationDegrees
                                            
                                        }
 
                                    }
                                    
                                }
                            }
                            
                            self.tableView.reloadData()
                        })
                        /*
                        print(self.timeArray)
                        print(self.tempArray)
                        print(self.descriptionArray)
 
                        
                        print((((jsonResult["city"] as? NSDictionary)?["coord"] as? NSDictionary)?["lat"] as? CLLocationDegrees)!)
                        print(self.latitudeGiven)
                        print(self.longitudeGiven)
                        */
                    } catch {
                        
                    }
                }
            }
        }
        task.resume()
    
    }
    
    @IBAction func goToCurrent(_ sender: Any) {
        
        performSegue(withIdentifier: "WeekToCurrent", sender: self)
    }
    
    @IBAction func goToGoogleMaps(_ sender: Any) {
        
        performSegue(withIdentifier: "WeekToGoogleMaps", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeekTableViewCell
        
        cell.desLabel.text = descriptionArray[indexPath.row]
        cell.tempLabel.text = String("\(tempArray[indexPath.row])°C")
        
        let format = "yyyy-MM-dd HH:mm:ss"
        let date = timeArray[indexPath.row].toDateString(inputFormat: format, outputFormat: "dd MMM yy HH:mm")!
        
        cell.dateLabel.text = date

        cell.backgroundColor = .clear
        
        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "WeekToCurrent" {
            
            let controller = (segue.destination) as! CurrentWeatherViewController
            
            if fromGoogleMaps == false {
                controller.stringCity = stringCity
                controller.originalTextInput = originalTextInput
                controller.fromGoogleMaps = fromGoogleMaps      // false
                
            } else if fromGoogleMaps == true {
                controller.latitudeGiven = latitudeGiven
                controller.longitudeGiven = longitudeGiven
                controller.fromGoogleMaps = fromGoogleMaps      // true
                
            }
        } else if segue.identifier == "WeekToGoogleMaps" {
            
            let controller = (segue.destination) as! OtherViewController
            
            controller.latitudeGiven = latitudeGiven
            controller.longitudeGiven = longitudeGiven
        }
    }
}
