//
//  OtherViewController.swift
//  API Demo
//
//  Created by Aaron Elijah on 19/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit
import GoogleMaps

/*
 Next, in the right one enable Maps SDK for iOS by clicking on the Off button - basically had to log in to my API manager at https://console.developers.google.com/apis/library?project=advancedweatherapp for my project "advancedweatherapp" and then click on Google Map SDK for iOS. Then I had to enable that API for this project. I had already used my API Key in AppDelegate and have the correct Bundle Indentifier to have access one that particular iOS key.
 */

class OtherViewController: UIViewController, GMSMapViewDelegate {
    
    var mapView : GMSMapView!
    
    var text = ""
    
    var latitudeGiven : CLLocationDegrees = -33.86
    var longitudeGiven : CLLocationDegrees = 151.20
    
    var toBeSentLatitude : CLLocationDegrees!
    var toBeSentLongitude : CLLocationDegrees!
    
    var camera = GMSCameraPosition()
    var layer = GMSURLTileLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // setup map view
        camera = GMSCameraPosition.camera(withLatitude: latitudeGiven, longitude: longitudeGiven, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        // mapView.settings.zoomGestures = true
        mapView.settings.compassButton = true
        mapView.delegate = self
        self.view = mapView
        
        
        // create a marker in the center of the app - centered on Sydney, Australia
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitudeGiven, longitude: longitudeGiven)
       
        /*
        
        // let urls = GMSTileURLConstructor
        
        let urls : GMSTileURLConstructor = { (x, y, zoom)
 
        }
        */
 
 
        let coordinate = CLLocationCoordinate2DMake(latitudeGiven, longitudeGiven)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines!
                print(lines)
                
                marker.title = lines[0]
                marker.snippet = lines[1]
                
            }
        }
        
        marker.map = mapView
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        print(camera.zoom)
        
        let marker = GMSMarker()
        
        marker.position = coordinate
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines!
                print(lines)
                
                marker.title = lines[0]
                marker.snippet = lines[1]
                
            } else {
                marker.title = "Marker"
            }
        }
        
        marker.map = mapView
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Marker tapped")
 
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("Info Window Tapped")
        
        createAlert(title: "Options", message: "Please pick one", marker: marker)
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "Change Weather Tiles", message: "Please pick one", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Temperature", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.layer.map = nil
            
            let urls : GMSTileURLConstructor = {(x: UInt, y: UInt, zoom: UInt) in
                let url = "http://tile.openweathermap.org/map/temp_new/\(zoom)/\(x)/\(y).png?appid=6ca1ae2dc9adc508f7b6712077e61fc2"
                return URL(string: url)
            }
            
            self.layer = GMSURLTileLayer(urlConstructor: urls)
            
            self.layer.zIndex = 50
            self.layer.map = mapView
        }))
        
        alert.addAction(UIAlertAction(title: "Pressure", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.layer.map = nil
            
            let urls : GMSTileURLConstructor = {(x: UInt, y: UInt, zoom: UInt) in
                let url = "http://tile.openweathermap.org/map/pressure_new/\(zoom)/\(x)/\(y).png?appid=6ca1ae2dc9adc508f7b6712077e61fc2"
                return URL(string: url)
            }
            
            self.layer = GMSURLTileLayer(urlConstructor: urls)
            
            self.layer.zIndex = 50
            self.layer.map = mapView
        }))
        
        alert.addAction(UIAlertAction(title: "Precipitation", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.layer.map = nil
            
            let urls : GMSTileURLConstructor = {(x: UInt, y: UInt, zoom: UInt) in
                let url = "http://tile.openweathermap.org/map/precipitation_new/\(zoom)/\(x)/\(y).png?appid=6ca1ae2dc9adc508f7b6712077e61fc2"
                return URL(string: url)
            }
            
            self.layer = GMSURLTileLayer(urlConstructor: urls)
            
            self.layer.zIndex = 50
            self.layer.map = mapView
        }))
        
        alert.addAction(UIAlertAction(title: "Clear", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.layer.map = nil
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func createAlert(title: String, message: String, marker: GMSMarker) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Weather", style: UIAlertActionStyle.default, handler: { (action) in
            
            // self.dismiss will dismiss the PostViewController so it dismisses that instead
            alert.dismiss(animated: true, completion: nil)
            self.toBeSentLatitude = marker.position.latitude
            self.toBeSentLongitude = marker.position.longitude
            
            self.performSegue(withIdentifier: "GoogleMapsToCurrent", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            marker.map = nil
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
            
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoogleMapsToCurrent" {
            let controller = (segue.destination) as! CurrentWeatherViewController
            
            controller.fromGoogleMaps = true
            controller.latitudeGiven = toBeSentLatitude
            controller.longitudeGiven = toBeSentLongitude
            
        }
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
