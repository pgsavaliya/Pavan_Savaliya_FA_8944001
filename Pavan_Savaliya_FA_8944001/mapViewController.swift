//
//  mapViewController.swift
//  Pavan_Savaliya_FA_8944001
//
//  Created by Pavan savaliya on 2024-04-12.
//

import UIKit
import MapKit
import CoreLocation
var StoreStartCityName = ""
var StoreEndCityName = ""
var travelType = ""
class mapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBAction func btnHome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Map"
    }
    
    @IBAction func btnNews(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "newsViewController") as! newsViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Map"
        
    }
    
    
    @IBAction func btnDirection(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! mapViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Map"
        
    }
    
    
    @IBAction func brnWeather(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "weatherViewController") as! weatherViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Map"
    }
    
    
    @IBOutlet weak var zoomSlider: UISlider!

    @IBAction func slider(_ sender: UISlider) {
        zoomMap(sender.value)
    }
    @IBAction func btnCar(_ sender: Any) {
        print("Car selected")
        travelType = "Car"
        currentTransportType = .automobile
        updateRoute()
    }
    @IBAction func btnBike(_ sender: Any) {
        print("Bike selected")
        travelType = "Bike"
        currentTransportType = .automobile
        updateRoute()
    }
    @IBAction func btnBus(_ sender: Any) {
        print("Bus selected")
        travelType = "Bus"
        currentTransportType = .transit
        updateRoute()
    }
    @IBAction func btnWalk(_ sender: Any) {
        print("Walking selected")
        travelType = "Walk"
        currentTransportType = .walking
        updateRoute()
    }
    
    @IBAction func btnPlus(_ sender: Any) {
        print("btnPlus tapped")
        promptForLocation()
    }
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    // Start and end point annotations
    var startPointAnnotation: MKPointAnnotation?
    var endPointAnnotation: MKPointAnnotation?
    var currentTransportType: MKDirectionsTransportType = .automobile

    
    private func zoomMap(_ zoomLevel: Float) {
        let center = mapView.centerCoordinate
        // Exponential scale: Adjust these values to change the zoom sensitivity
        let minZoom = 0.001
        let maxZoom = 0.8
        let zoomExponent = 4.0 * Double(zoomLevel)
        let zoom = minZoom * pow(10, zoomExponent * (maxZoom - minZoom))

        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func updateRoute() {
            guard let startCoordinates = startPointAnnotation?.coordinate, let endCoordinates = endPointAnnotation?.coordinate else { return }
            clearOverlays()

            let startPlacemark = MKPlacemark(coordinate: startCoordinates)
            let endPlacemark = MKPlacemark(coordinate: endCoordinates)

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: startPlacemark)
            directionRequest.destination = MKMapItem(placemark: endPlacemark)
            directionRequest.transportType = currentTransportType

            let directions = MKDirections(request: directionRequest)
            directions.calculate { [weak self] (response, error) in
                guard let strongSelf = self, let route = response?.routes.first else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                strongSelf.mapView.addOverlay(route.polyline, level: .aboveRoads)
                let rect = route.polyline.boundingMapRect
                strongSelf.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                let startLocation = CLLocation(latitude: startCoordinates.latitude, longitude: startCoordinates.longitude)
                    let endLocation = CLLocation(latitude: endCoordinates.latitude, longitude: endCoordinates.longitude)

                var distance = startLocation.distance(from: endLocation) / 1000
                let MapHistory: [HistoryDataStruct] = [ HistoryDataStruct(pageName:"Map", cityName:cityName, fromPageName:fromPage,startPoint:StoreStartCityName,endpoint:StoreEndCityName ,distance:String(distance) ,modeOfTravel:travelType)]
                setDataInDatabase(MapHistory)
                cityName = StoreEndCityName
        }

        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, startPointAnnotation == nil {
            setStartLocation(location: location)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        }
    }

    private func setStartLocation(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Start Location"
        mapView.addAnnotation(annotation)
        startPointAnnotation = annotation
    }
    
    private func promptForLocation() {
        if let location = locationManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self = self else { return }
                var initialText = ""
                if let placemark = placemarks?.first {
                    initialText = placemark.locality ?? (placemark.administrativeArea ?? "")
                }
                self.showAlertWithInitialText(initialText)
            }
        } else {
            showAlertWithInitialText("")
        }
    }
    
    private func showAlertWithInitialText(_ initialText: String) {
        let alertController = UIAlertController(title: "Set Start and Destination", message: "Enter start and destination city names", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Start city name"
            textField.text = initialText
        }
        alertController.addTextField { textField in
            textField.placeholder = "Destination city name"
        }
        let submitAction = UIAlertAction(title: "Directions", style: .default) { [unowned alertController, weak self] _ in
            guard let startCityName = alertController.textFields?.first?.text, let endCityName = alertController.textFields?.last?.text, let self = self else { return }
            self.setStartPoint(cityName: startCityName)
            StoreStartCityName = startCityName
            StoreEndCityName = endCityName
            self.setEndPoint(cityName: endCityName)
        }
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
           }
        alertController.addAction(cancelAction)

        DispatchQueue.main.async {
            if self.presentedViewController == nil {
                self.present(alertController, animated: true)
            } else {
                print("A view controller is already presented.")
            }
        }
    }
        private func setStartPoint(cityName: String) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to geocode city: \(error)")
                    return
                }
                if let placemark = placemarks?.first, let location = placemark.location {
                    self.clearMapAnnotations()
                    self.clearOverlays()
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = "Start Location: \(cityName)"
                    self.mapView.addAnnotation(annotation)
                    self.startPointAnnotation = annotation
                    self.drawRoute()
                } else {
                    print("No location found for \(cityName)")
                }
            }
        }

        private func setEndPoint(cityName: String) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to geocode city: \(error)")
                    return
                }
                if let placemark = placemarks?.first, let location = placemark.location {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = "End Location: \(cityName)"
                    self.mapView.addAnnotation(annotation)
                    self.endPointAnnotation = annotation
                    self.drawRoute()
                } else {
                    print("No location found for \(cityName)")
                }
            }
        }

        private func drawRoute() {
            guard let startCoordinates = startPointAnnotation?.coordinate, let endCoordinates = endPointAnnotation?.coordinate else { return }
            clearOverlays()
            
            let startLocation = CLLocation(latitude: startCoordinates.latitude, longitude: startCoordinates.longitude)
                let endLocation = CLLocation(latitude: endCoordinates.latitude, longitude: endCoordinates.longitude)

            var distance = startLocation.distance(from: endLocation) / 1000

            let startPlacemark = MKPlacemark(coordinate: startCoordinates)
            let endPlacemark = MKPlacemark(coordinate: endCoordinates)
            

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: startPlacemark)
            directionRequest.destination = MKMapItem(placemark: endPlacemark)
            directionRequest.transportType = .automobile

            let directions = MKDirections(request: directionRequest)
            directions.calculate { [weak self] (response, error) in
                guard let strongSelf = self else { return }
                if let route = response?.routes.first {
                    strongSelf.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    strongSelf.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    let storestartpoint = StoreStartCityName
                    
                    
                    
                    let MapHistory: [HistoryDataStruct] = [ HistoryDataStruct(pageName:"Map", cityName:cityName, fromPageName:fromPage,startPoint:StoreStartCityName,endpoint:StoreEndCityName ,distance:String(distance) ,modeOfTravel:"Car")]
                    setDataInDatabase(MapHistory)
                    cityName = StoreEndCityName
                    
                } else if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polylineOverlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polylineOverlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
        private func clearMapAnnotations() {
            mapView.removeAnnotations(mapView.annotations)
        }

        private func clearOverlays() {
            mapView.removeOverlays(mapView.overlays)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
