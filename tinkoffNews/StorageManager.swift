//
//  StorageManager.swift
//  tinkoffNews
//
//  Created by Ilya on 05.02.2023.
//
import Foundation
class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private init() {}
    func upload(counter: [Article:Int], forPageKey key: String) {
        for (key, value) in counter {
        userDefaults.set(value, forKey: key.url!)
        }
    }
    func upload(article: Article,count:Int, forPageKey key: String) {
            userDefaults.set(count, forKey: article.url!)
    }
    func saveImageData(data: Data, withKey key: String) {
        userDefaults.set(data, forKey: key)
    }
    func fetchImageData(forKey key: String) -> Data? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return data
    }
    func saveViewsCounterValue(count: Int, forKey key: String) {
        userDefaults.set(count, forKey: key)
    }
    func fetchViewsCounterValue(forKey key: String) -> Int? {
        return userDefaults.integer(forKey: key)
    }
}

