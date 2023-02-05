//
//  ViewController.swift
//  tinkoffNews
//
//  Created by Ilya on 05.02.2023.
//

import UIKit
import SafariServices
var counter: [Article:Int] = [:]

class NewsViewController: UITableViewController {
private let urlSrting = "https://newsapi.org/v2/everything?q=Apple&from=2023-02-05&sortBy=popularity&apiKey=392ed9fdb96a4f2f916b74f2440eecdf"
private let cellID = "cell"
private var news: News?
private lazy var newsArticle: [Article] = []
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    tableView.backgroundColor = .red
    tableView.rowHeight = 100
    tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil),
                       forCellReuseIdentifier: cellID)
    setData()
    refresh()
    let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
    self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "tableviewloadingcellid")
}
}
extension NewsViewController {
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    newsArticle.count
}
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? NewsTableViewCell {
        let object = newsArticle[indexPath.row]
        cell.configure(with: object)
        return cell
    }
    return UITableViewCell()
}
}
extension NewsViewController {
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let newsDetailsVC = NewsDetailsViewController()
    navigationController?.pushViewController(newsDetailsVC, animated: true)
    let detailsNews = newsArticle[indexPath.row]
    newsDetailsVC.newsDetails = detailsNews
}
}
extension NewsViewController {
private func setData() {
    NetworkManager.shared.fetchData(from: urlSrting) { [weak self] news in
        DispatchQueue.main.async {
        var counts:Int=0
            self?.news = news
            self?.news?.articles?.forEach({ value in
                counter[value]=0
                if Int.random(in: 1..<2)==1 && counts<=7 {
                    self?.newsArticle.append(value)
                    counts+=1
                    if StorageManager.shared.fetchViewsCounterValue(forKey: value.url!) == nil {
                        StorageManager.shared.upload(article: value, count: counter[value]!, forPageKey: value.url!)
                    }
                }
            })
            self?.tableView.reloadData()
        }
    }
}
private func refresh() {
    refreshControl = UIRefreshControl()
    refreshControl?.attributedTitle = NSAttributedString()
    refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
    tableView.addSubview(refreshControl ?? UIRefreshControl())
}
@objc private func update() {
    NetworkManager.shared.fetchData(from: urlSrting) { [weak self] news in
        self?.news = news
        var counts:Int = 0
        self?.newsArticle.removeAll()
        self?.news?.articles?.forEach({ value in
            if Int.random(in: 1..<5)==1 && counts<=7 {
                self?.newsArticle.append(value)
                let keyExists = counter[value] != nil
                if !keyExists {
                    counter[value]=0
                }
                StorageManager.shared.upload(article: value, count: counter[value]!, forPageKey: value.url!)
                counts+=1
            }
           
        })
        DispatchQueue.main.async {
            self?.newsArticle.shuffle()
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
}

}
class NewsDetailsViewController: UIViewController {
    var updateCounter = 0
    
    private lazy var author: UILabel = {
        let label = UILabel()
        if let text=newsDetails.author {
            label.text = "Author: "+text
        }
        else {
            label.text = "Noname author"
        }
        label.font = UIFont.systemFont(ofSize:11)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = newsDetails.content
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var published: UILabel = {
        let label = UILabel()
        if let text = newsDetails.publishedAt {
            label.text = "Published at: "+text
        }
        else {
            label.text = "Publication date unknown"
        }
        label.font = UIFont.systemFont(ofSize:11)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var source: UILabel = {
        let label = UILabel()
        if let text = newsDetails.url {
            label.text = "Sorce: "+text
        }
        else {
            label.text = "No source"
        }
        label.font = UIFont.systemFont(ofSize:11)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var rank: UILabel = {
        let label = UILabel()
        label.text = newsDetails.title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize:23)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var image: ImageView = {
        let image = ImageView()
        image.contentMode = .scaleAspectFill
        image.fetchImage(from: newsDetails.urlToImage ?? "")
        return image
    }()
    
    private lazy var newsButton: UIButton = {
        let fullNewsButton = UIButton()
        fullNewsButton.backgroundColor = UIColor(red: 90/255, green: 11/255, blue: 19/255, alpha: 1)
        
        fullNewsButton.setTitle("go to site", for: .normal)
        fullNewsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        fullNewsButton.setTitleColor(.white, for: .normal)
        
        fullNewsButton.layer.cornerRadius = 10
        fullNewsButton.addTarget(self, action: #selector(goToFullNews), for: .touchUpInside)
        
        return fullNewsButton
    }()
   
    var newsDetails: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        counter[newsDetails]!+=1
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        setupSubviews()
        setConstrains()
    }
    
    // MARK: - Actions
    @objc private func goToFullNews() {
        let fullNews = SFSafariViewController(url: URL(string: newsDetails.url ?? "")!)
        present(fullNews, animated: true)
    }
    
    // MARK: - Private methods
    private func setupSubviews() {
        view.addSubview(rank)
        view.addSubview(image)
        view.addSubview(author)
        view.addSubview(published)
        view.addSubview(descriptionLabel)
        view.addSubview(source)
        view.addSubview(newsButton)
        
    }
    
    private func setConstrains() {
      
        rank.translatesAutoresizingMaskIntoConstraints = false
        rank.textColor = .white
       
        
        NSLayoutConstraint.activate([
            rank.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            rank.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rank.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rank.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            //rank.textColor = [ UIColor(red: 10/255, green: 20/255, blue: 15/255, alpha: 1)]
            
        ])
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 400)
        ])
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 80),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        author.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            author.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            author.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            author.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
        published.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            published.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 10),
            published.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            published.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
        
        source.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            source.topAnchor.constraint(equalTo: published.bottomAnchor, constant: 30),
            source.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            source.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        newsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsButton.topAnchor.constraint(equalTo: source.bottomAnchor, constant: 20),
            newsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }
    
    
}





