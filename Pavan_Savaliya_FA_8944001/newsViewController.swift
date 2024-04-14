//
//  newsViewController.swift
//  Pavan_Savaliya_FA_8944001
//
//  Created by Pavan savaliya on 2024-04-12.
//
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}


class NewsTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let authorLabel = UILabel()
    let sourceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure label properties
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        authorLabel.font = UIFont.italicSystemFont(ofSize: 14)
        sourceLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Add labels to the contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(sourceLabel)
        
        // Set constraints for labels
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            sourceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}
import UIKit

var contry: String = "us"
class newsViewController: UIViewController, UITableViewDataSource {
    @IBAction func btnHome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "News"
    }
    
    @IBAction func btnNews(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "newsViewController") as! newsViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "News"
    }
    
    
    @IBAction func btnDirection(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! mapViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "News"
    }
    
    
    @IBAction func brnWeather(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let premiumVC = storyboard.instantiateViewController(withIdentifier: "weatherViewController") as! weatherViewController
                premiumVC.modalPresentationStyle = .fullScreen
                self.present(premiumVC, animated: true)
        fromPage = "News"
    }
    
    
    @IBAction func btnPlus(_ sender: Any) {
     
            let alertController = UIAlertController(title: "Enter Contry Name", message: "Please enter the name of a contry.", preferredStyle: .alert)
            
            // Text field for city name entry
            alertController.addTextField { (textField) in
                textField.placeholder = "contry code"
            }
            // Action for the News button
                let submitAction = UIAlertAction(title: "submit", style: .default) { [unowned alertController] _ in
                    let contryName = alertController.textFields![0].text ?? contry
                    if(contryName != ""){
                        contry = contryName
                        self.newAPI()
                    }
                }
            
            // Adding all actions to the alert controller
            alertController.addAction(submitAction)
            
            // Presenting the alert
            present(alertController, animated: true)
    }
    
    @IBOutlet weak var tblNews: UITableView!
    var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tblNews.dataSource = self
        tblNews.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        newAPI()
    }

    func newAPI() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(contry)&apiKey=100d5fb67f604197bedd5a1034b43211"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data:", error)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    if(!newsResponse.articles.isEmpty){
                        self.articles = newsResponse.articles
                        self.tblNews.reloadData()
                    }
                }
            } catch {
                print("Error decoding JSON:", error)
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    var newsCounter = 0

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
           let article = articles[indexPath.row]
           
           // Create attributed strings for each element with bold headings
           let boldTitle = NSMutableAttributedString(string: "Title: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
           let boldDescription = NSMutableAttributedString(string: "Description: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
           let boldAuthor = NSMutableAttributedString(string: "Author: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
           let boldSource = NSMutableAttributedString(string: "Source: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
           
           // Set the content for each element
           let title = NSAttributedString(string: article.title)
           let description = NSAttributedString(string: article.description ?? "Description not available")
           let author = NSAttributedString(string: article.author ?? "Author not available")
           let source = NSAttributedString(string: article.source.name)
           
           // Append content to each bold heading
           boldTitle.append(title)
           boldDescription.append(description)
           boldAuthor.append(author)
           boldSource.append(source)
        
            // Set attributed strings as text for each label
            cell.titleLabel.attributedText = boldTitle
            cell.descriptionLabel.attributedText = boldDescription
            cell.authorLabel.attributedText = boldAuthor
            cell.sourceLabel.attributedText = boldSource
        if(newsCounter == 0){
            let NewsHistory: [HistoryDataStruct] = [ HistoryDataStruct(pageName:"News", cityName:contry, fromPageName:fromPage,titleOftheArticle: article.title, bookDescription: article.description, theAuthor: article.author, theSource: article.source.name)]
            setDataInDatabase(NewsHistory)
            newsCounter = 1
        }
           return cell
    }
}
