//
//  View.swift
//  tinkoffNews
//
//  Created by Ilya on 05.02.2023.
//
import UIKit
class ImageView: UIImageView {
    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else {
           
            return
        }
        if let cachedImage = getCachedImage(from: imageURL) {
            image = cachedImage
            return
        }
        ImageManager.shared.getImage(from: imageURL) { [weak self] (data, response) in
            DispatchQueue.main.async {
             
                if StorageManager.shared.fetchImageData(forKey: url) == nil {
                    StorageManager.shared.saveImageData(data: data, withKey: url)
                }
                self?.image = UIImage(data:StorageManager.shared.fetchImageData(forKey: url)!)
            }
            self?.saveDataToCach(with: data, and: response)
        }
    }
    private func getCachedImage(from url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    private func saveDataToCach(with data: Data, and response: URLResponse) {
        guard let urlResponse = response.url else { return }
        let urlRequest = URLRequest(url: urlResponse)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}
import UIKit
class NewsTableViewCell: UITableViewCell {
    @IBOutlet var imageNewsView: ImageView!
    {
        didSet
        {
            imageNewsView.contentMode = .scaleAspectFill
            imageNewsView.clipsToBounds = true
            imageNewsView.layer.cornerRadius = 40
        }
    }
    @IBOutlet var titleNewsLabel: UILabel!
    @IBOutlet var touchCounterLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with article: Article) {
        titleNewsLabel.text = article.title
           touchCounterLabel.text = String(StorageManager.shared.fetchViewsCounterValue(forKey: article.url!)!)
        guard let imageURL = article.urlToImage else { return }
        imageNewsView.fetchImage(from: imageURL)
    }
    func configure_counter(with article: Article) {
        touchCounterLabel.text = String(counter[article]!)
    }

}
