//
//  Model.swift
//  tinkoffNews
//
//  Created by Ilya on 05.02.2023.
//
import Foundation
struct News: Codable {
    var articles: [Article]?
}
struct Article: Codable,Hashable {
    let author, title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

