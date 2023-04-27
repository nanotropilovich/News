# 🚀 News 📰

A **simple yet powerful** news application for iOS that fetches articles from a specified API, and tracks article views using UserDefaults. It also provides caching for images to optimize network usage. Get the **latest and hottest news** right at your fingertips! 🌟

## 🌟 Features

- 🌐 Fetch news articles from a specified API
- 📊 Track and store article view count using UserDefaults
- 🖼️ Cache images for better performance and reduced network usage
- ♻️ Singleton pattern for managing network and storage operations

## 🛠️ Installation

1. 📂 Clone the repository or download the source code.
2. 🖥️ Open the project in Xcode.
3. 🔗 Add the API URL to the `fetchData` function in the `NetworkManager` class.

## 📚 Usage

### 🌐 NetworkManager

The `NetworkManager` class is responsible for fetching data from the specified API.

```swift
NetworkManager.shared.fetchData(from: urlString) { news in
    // Handle the fetched data 🚀
}
## 🖼️ ImageManager
The ImageManager class is responsible for fetching images from the specified URL.


ImageManager.shared.getImage(from: url) { (data, response) in
    // Handle the fetched image data 🌈
}
```
💾 StorageManager
The StorageManager class is responsible for storing and fetching data using UserDefaults.

```swift
// Save image data 🖼️
StorageManager.shared.saveImageData(data: imageData, withKey: key)

// Fetch image data 🧐
let imageData = StorageManager.shared.fetchImageData(forKey: key)

// Save views counter value 📊
StorageManager.shared.saveViewsCounterValue(count: count, forKey: key)

// Fetch views counter value 📈
let count = StorageManager.shared.fetchViewsCounterValue(forKey: key)
```
