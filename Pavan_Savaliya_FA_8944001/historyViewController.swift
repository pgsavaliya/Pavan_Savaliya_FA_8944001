//
//  historyViewController.swift
//  Pavan_Savaliya_FA_8944001
//
//  Created by Pavan savaliya on 2024-04-12.
//

import UIKit
import CoreData
struct HistoryDataStruct {
    var pageName: String
    var cityName: String?
    var fromPageName: String?
    var titleOftheArticle: String?
    var bookDescription: String?
    var theAuthor: String?
    var theSource: String?
    var date: String?
    var time: String?
    var temp: String?
    var humidity: String?
    var wind: String?
    var startPoint: String?
    var endpoint: String?
    var distance: String?
    var modeOfTravel: String?
}
var historyData: [HistoryDataStruct] = []
class historyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func btnHome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyData.removeAll()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        
        getDataFromDatabase()
        
        // Set up table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    //MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath)
        let data = historyData[indexPath.row]
        
        let pageNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        pageNameLabel.text = data.pageName
        pageNameLabel.layer.borderWidth = 1.0 
        pageNameLabel.numberOfLines = 0
        pageNameLabel.layer.borderColor = UIColor.black.cgColor
        cell.contentView.addSubview(pageNameLabel)
        
        let cityNameLabel = UILabel(frame: CGRect(x: 120, y: 0, width: 100, height:20))
        cityNameLabel.text = data.cityName
        cell.addSubview(cityNameLabel)
        
        let fromPageNameLabel = UILabel(frame: CGRect(x: 240, y: 0, width: 100, height: 20))
        fromPageNameLabel.text = data.fromPageName
        cell.addSubview(fromPageNameLabel)
        
        if data.pageName == "News" {
            let titleOftheArticleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 400, height: 20))
            titleOftheArticleLabel.text = "Title:\(data.titleOftheArticle ?? "")"
            titleOftheArticleLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(titleOftheArticleLabel)
            
            let bookDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 400, height: 40))
            bookDescriptionLabel.text = "Description: \(data.bookDescription ?? "")"
            bookDescriptionLabel.numberOfLines = 0
            bookDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(bookDescriptionLabel)
            
            let theAuthorLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 200, height: 20))
            theAuthorLabel.text = "Author: \(data.theAuthor ?? "")"
            theAuthorLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(theAuthorLabel)
            
            let theSourceLabel = UILabel(frame: CGRect(x: 200, y: 80, width: 200, height: 20))
            theSourceLabel.text = "Source: \(data.theSource ?? "")"
            theSourceLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(theSourceLabel)
        } else if data.pageName == "Weather" {
            let dateLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 120, height: 40))
            dateLabel.text = "Date: \(data.date ?? "")"
            dateLabel.numberOfLines = 0
            dateLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(dateLabel)
            
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 120, height: 20))
            timeLabel.text = "Time: \(data.time ?? "")"
            timeLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(timeLabel)
            
            let tempLabel = UILabel(frame: CGRect(x: 120, y: 20, width: 120, height: 20))
            tempLabel.text = "Temp: \(data.temp ?? "")"
            tempLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(tempLabel)
            
            let humidityLabel = UILabel(frame: CGRect(x: 120, y: 40, width: 120, height: 20))
            humidityLabel.text = "Huminity: \(data.humidity ?? "")"
            humidityLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(humidityLabel)
            
            let windLabel = UILabel(frame: CGRect(x: 120, y: 60, width: 120, height: 20))
            windLabel.text = "Wind: \(data.wind ?? "")"
            windLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(windLabel)
            
        } else {
            let startPointLabel = UILabel(frame: CGRect(x: 00, y: 20, width: 300, height: 20))
            startPointLabel.text = "StartPoint: \(data.startPoint ?? "")"
            startPointLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(startPointLabel)
            
            let endpointLabel = UILabel(frame: CGRect(x: 00, y: 40, width: 300, height: 20))
            endpointLabel.text = "EndPoint: \(data.endpoint ?? "")"
            endpointLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(endpointLabel)
            
            let distanceLabel = UILabel(frame: CGRect(x: 00, y: 60, width: 300, height: 20))
            distanceLabel.text = "Distance: \(data.distance ?? "")"
            distanceLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(distanceLabel)
            
            let modeOfTravelLabel = UILabel(frame: CGRect(x: 00, y: 80, width: 300, height: 20))
            modeOfTravelLabel.text = "Mode Of Travel: \(data.modeOfTravel ?? "")"
            modeOfTravelLabel.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(modeOfTravelLabel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    //MARK: - Table View Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // Allow deleting rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the history data item
            let deletedItem = historyData.remove(at: indexPath.row)
            // Delete corresponding data from Core Data
            removeDataFromDatabase(historyItem: deletedItem)
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Set editing style to delete
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //MARK: - Core Data Operations
    
    func getDataFromDatabase() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryData")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let historyItem = HistoryDataStruct(
                    pageName: data.value(forKey: "pageName") as! String,
                    cityName: data.value(forKey: "cityName") as? String,
                    fromPageName: data.value(forKey: "fromPageName") as? String,
                    titleOftheArticle: data.value(forKey: "titleOftheArticle") as? String,
                    bookDescription: data.value(forKey: "bookDescription") as? String,
                    theAuthor: data.value(forKey: "theAuthor") as? String,
                    theSource: data.value(forKey: "theSource") as? String,
                    date: data.value(forKey: "date") as? String,
                    time: data.value(forKey: "time") as? String,
                    temp: data.value(forKey: "temp") as? String,
                    humidity: data.value(forKey: "humidity") as? String,
                    wind: data.value(forKey: "wind") as? String,
                    startPoint: data.value(forKey: "startPoint") as? String,
                    endpoint: data.value(forKey: "endpoint") as? String,
                    distance: data.value(forKey: "distance") as? String,
                    modeOfTravel: data.value(forKey: "modeOfTravel") as? String
                )
                historyData.append(historyItem)
            }
            // Reload table view after fetching data
            tableView.reloadData()
        } catch let error as NSError {
            print("Error in get: \(error)")
        }
    }
    
    func removeDataFromDatabase(historyItem: HistoryDataStruct) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryData")
        fetchRequest.predicate = NSPredicate(format: "pageName = %@", historyItem.pageName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let objectToDelete = result.first as? NSManagedObject {
                managedContext.delete(objectToDelete)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Error in remove: \(error)")
        }
    }
}
//MARK: set data
func setDataInDatabase(_ historyDataArray: [HistoryDataStruct]) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let historyEntity = NSEntityDescription.entity(forEntityName: "HistoryData", in: managedContext)!
    
    for historyData in historyDataArray {
        
        let historyManagedObject = NSManagedObject(entity: historyEntity, insertInto: managedContext)
        if !historyData.pageName.isEmpty {
            historyManagedObject.setValue(historyData.pageName, forKey: "pageName")
        }
        
        if let cityName = historyData.cityName, !cityName.isEmpty {
            historyManagedObject.setValue(cityName, forKey: "cityName")
        }
        if let fromPageName = historyData.fromPageName, !fromPageName.isEmpty {
            historyManagedObject.setValue(historyData.fromPageName, forKey:
                                            "fromPageName")
        }
        if let titleOftheArticle = historyData.titleOftheArticle, !titleOftheArticle.isEmpty {
            historyManagedObject.setValue(historyData.titleOftheArticle, forKey: "titleOftheArticle")
        }
        if let bookDescription = historyData.bookDescription, !bookDescription.isEmpty {
            historyManagedObject.setValue(historyData.bookDescription, forKey: "bookDescription")
        }
        if let theAuthor = historyData.theAuthor, !theAuthor.isEmpty {
            historyManagedObject.setValue(historyData.theAuthor, forKey: "theAuthor")
        }
        if let theSource = historyData.theSource, !theSource.isEmpty {
            historyManagedObject.setValue(historyData.theSource, forKey: "theSource")
        }
        if let date = historyData.date, !date.isEmpty {
            historyManagedObject.setValue(historyData.date, forKey: "date")
        }
        if let time = historyData.time, !time.isEmpty {
            historyManagedObject.setValue(historyData.time, forKey: "time")
        }
        if let temp = historyData.temp, !temp.isEmpty {
            historyManagedObject.setValue(historyData.temp, forKey: "temp")
        }
        if let humidity = historyData.humidity, !humidity.isEmpty {
            historyManagedObject.setValue(historyData.humidity, forKey: "humidity")
        }
        if let wind = historyData.wind, !wind.isEmpty {
            historyManagedObject.setValue(historyData.wind, forKey: "wind")
        }
        if let startPoint = historyData.startPoint, !startPoint.isEmpty {
            historyManagedObject.setValue(historyData.startPoint, forKey: "startPoint")
        }
        if let endpoint = historyData.endpoint, !endpoint.isEmpty {
            historyManagedObject.setValue(historyData.endpoint, forKey: "endpoint")
        }
        if let distance = historyData.distance, !distance.isEmpty {
            historyManagedObject.setValue(historyData.distance, forKey: "distance")
        }
        if let modeOfTravel = historyData.modeOfTravel, !modeOfTravel.isEmpty {
            historyManagedObject.setValue(historyData.modeOfTravel, forKey: "modeOfTravel")
        }
    }

    do {
        
        try managedContext.save()
    } catch let error as NSError {
        print("Error in add: \(error)")
    }
}
