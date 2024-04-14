//
//  weatherViewController.swift
//  Pavan_Savaliya_FA_8944001
//
//  Created by Pavan savaliya on 2024-04-12.
//

import UIKit

class weatherViewController: UIViewController {
    @IBAction func btnHome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Weather"
    }
    
    @IBAction func btnNews(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "newsViewController") as! newsViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Weather"
        
    }
    
    
    @IBAction func btnDirection(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! mapViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Weather"
        
    }
    
    
    @IBAction func brnWeather(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "weatherViewController") as! weatherViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "Weather"
    }
    
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
   
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAPICall()

        // Do any additional setup after loading the view.
    }
    
    
     
    
    
    func makeAPICall() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=9a21054512ff21e333b5cbc826d23ac3"
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
                            self.lblCityName.text = cityName
                            self.lblDescription.text = jsonData.weather[0].description
                            self.lblTemp.text = "\(jsonData.main.temp)"
                            self.lblHumidity.text =  "\(jsonData.main.humidity)%"
                            self.lblWind.text =  "\(jsonData.wind.speed) km/h"
                            self.loadWeatherIcon(jsonData.weather[0].icon)
                            let currentDate = Date()
                            // Create a date formatter
                            let dateFormatter = DateFormatter()
                            let timeFormatter = DateFormatter()
                            // Set the date format
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            timeFormatter.dateFormat = "HH:mm:ss"
                            // Convert date to string
                            let dateString = dateFormatter.string(from: currentDate)
                            let timeString = timeFormatter.string(from: currentDate)

                        let weatherHistory: [HistoryDataStruct] = [ HistoryDataStruct(pageName:"Weather", cityName:cityName, fromPageName:fromPage, date: dateString, time: timeString, temp: "\(jsonData.main.temp)", humidity: "\(jsonData.main.humidity)%", wind: "\(jsonData.wind.speed) km/h")]
                            setDataInDatabase(weatherHistory)
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
                        self.imgIcon.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

}
