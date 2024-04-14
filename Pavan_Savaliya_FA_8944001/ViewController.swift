//
//  ViewController.swift
//  Pavan_Savaliya_FA_8944001
//
//  Created by Pavan savaliya on 2024-04-03.
//

import UIKit
import MapKit
import CoreLocation




var fromPage = "Home"
var cityName = ""
var latitude : Double = 0.0
var longitude : Double = 0.0

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBAction func btnNews(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "newsViewController") as! newsViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Home"
        
    }
    
    
    @IBAction func btnDirection(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! mapViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Home"
    }
    
    
    @IBAction func brnWeather(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "weatherViewController") as! weatherViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Home"
    }
    
    @IBAction func btnHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "historyViewController") as! historyViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
    }
    
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    var counter = 0
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations = locations.first{
            manager.startUpdatingLocation()
            if(counter == 0){
                findCityName(locations)
                makeAPICall()
                counter = 1
            }
            
            render(locations)
        }
    }
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
        
        
        
        
    }
    func findCityName(_ location: CLLocation){
        let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard error == nil else {
                    print("Reverse geocoding error: \(error!.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        cityName = city
                    } else {
                        print("City name not found")
                    }
                } else {
                    print("No placemarks found")
                }
            }
    }

        func makeAPICall() {
        guard let currentLocation = manager.location else {
            print("Unable to get current location.")
            return
        }
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=9a21054512ff21e333b5cbc826d23ac3"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let data = data {
                    do {
                        let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                        DispatchQueue.main.async {
                            self.lblTemp.text = "\(jsonData.main.temp)"
                            self.lblHumidity.text =  "\(jsonData.main.humidity)%"
                            self.lblWind.text =  "\(jsonData.wind.speed) km/h"
                            self.loadWeatherIcon(jsonData.weather[0].icon)
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                } else {
                    print("Error fetching data:", error ?? "Unknown error")
                }
            }
            task.resume()
    }
    func loadWeatherIcon(_ iconCode: String) {
        let iconURLString = "https://openweathermap.org/img/w/\(iconCode).png"
        if let iconURL = URL(string: iconURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: iconURL) {
                    DispatchQueue.main.async {
                        self.imgWeatherIcon.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}


