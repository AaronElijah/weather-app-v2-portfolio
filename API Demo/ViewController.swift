//
//  ViewController.swift
//  API Demo
//
//  Created by Aaron Elijah on 06/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    /*
    Credit for photo goes to Karen Emsley from https://unsplash.com
    The link to the photo is given below
    https://unsplash.com/?photo=eHpYD4U5830
    */

    let city : NSString = NSString()
    var stringCity : String = String()
    
    var currentWeatherViewController : CurrentWeatherViewController = CurrentWeatherViewController()
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var label: UILabel!
    
    @IBAction func submitPressed(_ sender: Any) {
        if textField.text == "" {
            // label.text = "Please enter something"
            
            createAlert(title: "Error", message: "Please enter something")
            
        } else {
        
            performSegue(withIdentifier: "MainToCurrent", sender: self)
        }
    }
    
    @IBAction func goToWeeklyForecast(_ sender: Any) {
        if textField.text == "" {
            // label.text = "Please enter something"
            
            createAlert(title: "Error", message: "Please enter something")
            
        } else {
            performSegue(withIdentifier: "MainToWeek", sender: self)
        }
        
    }
    
    @IBAction func goToGoogleMaps(_ sender: Any) {
        
        performSegue(withIdentifier: "MainToGoogleMaps", sender: nil)
        
    }
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            
            // self.dismiss will dismiss the PostViewController so it dismisses that instead
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToCurrent" {
            let controller = (segue.destination) as! CurrentWeatherViewController
            
            controller.originalTextInput = textField.text!
            controller.fromGoogleMaps = false
            
        } else if segue.identifier == "MainToWeek" {
            
            let controller = (segue.destination) as! WeekForecastViewController
            
            controller.originalTextInput = textField.text!
        } 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

