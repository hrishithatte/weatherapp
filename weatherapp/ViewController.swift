//
//  ViewController.swift
//  weatherapp
//
//  Created by Felix-ITS 004 on 19/12/18.
//  Copyright © 2018 sonal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//"https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=f61bab68a17d7c3d6f4a040638062f80"
class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate{

    let locationManager = CLLocationManager()
    var latitude : CGFloat = 0.0,longitude: CGFloat = 0.0
    
    @IBOutlet weak var mpview: MKMapView!
    
    @IBOutlet var lbltemp: UILabel!
    
    @IBOutlet var lblhum: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let geo = CLGeocoder()
        geo.geocodeAddressString(textField.text!) { (placemarks, error) in
            let placemark = placemarks?.first
            let location = placemark?.location
            let coordinate = location?.coordinate
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            self.mpview.setRegion(region, animated: true)
        }
        return true
    }
    
    func parsejson(urlString: String)
    {
        enum jsonError : String , Error
        {
            case responseError = "response not found"
            case dataerror = "data not found"
            case conversionError = "conversion failed"
        }
        guard let endPoint = URL(string: urlString)
        else
        {
            print("end point not found")
            return
        }
        URLSession.shared.dataTask(with: endPoint){(data,response,error)in
            do
            {
            guard let response1 = response
              else
            {
                throw jsonError.responseError
            }
            print(response1)
                guard let data = data
                else
                {
                   throw jsonError.dataerror
                }
                let firstArray : [String:Any] = try
                    JSONSerialization.jsonObject(with: data, options: []) as!
                        [String : Any]
                let mainDic : [String: Any] = firstArray["main"] as! [String: Any]
               let tempdbl = mainDic["temp"] as! Double
                print("temprature of the current location is\(tempdbl)")
                let hum = mainDic["humidity"] as! Double
                let temp2:String = String(format: "%f", hum)
                print("humidity of the place is\(temp2)")
                self.lbltemp.text = String(tempdbl)
                self.lblhum.text = String(temp2)
            }
            catch let error as jsonError
            {
                print(error.rawValue)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        } .resume()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startDetectingLocation()
    }
    
    func startDetectingLocation()
    {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        location: [CLLocation])
    {
        
        let currentLocation = location.last!
        latitude = CGFloat(currentLocation.coordinate.latitude)
        longitude = CGFloat(currentLocation.coordinate.longitude)
    }
    
    
    @IBAction func btshow(_ sender: UIButton){
     let urlstr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f61bab68a17d7c3d6f4a040638062f80"
     parsejson(urlString: urlstr)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

