//
//  API.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

struct ServerImage: Codable {
    let title: String
    let farm: Int
    let server: String
    let id: String
    let secret: String
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [ServerImage]
}


struct GalleryResponse: Codable {
    let photos: Photos
    let stat: String
}

enum Size: String {
    case small = "m"
    case large = "b"
}

class ServerConnection {
    var apiKey = "bbc5efcb126e58a1e6bd0628ce39da6d"
    
    func getGallery(id: String, completion: @escaping (GalleryResponse) -> Void) {
        let arguments: [String: String] = ["method": "flickr.galleries.getPhotos",
                                           "api_key": apiKey,
                                           "gallery_id": id,
                                           "format": "json",
                                           "nojsoncallback": "1"]
        if let url = url(endpoint: "flickr.galleries.getPhotos", arguments: arguments) {
            print("URL: \(url)")
            getRequest(url: url, completion: { data in
                let decoder = JSONDecoder()
                do {
                    let gallery = try decoder.decode(GalleryResponse.self, from: data)
                    completion(gallery)
                } catch {
                    print(error)
                }
            }, failure: { error in
                 print(error)
            })
        }
    }
    
    func getPhoto(_ photo: ServerImage, size: Size, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(size.rawValue).jpg"
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { print(error) ; return }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    func url(endpoint: String, arguments: [String: String]) -> URL? {
        let base = "https://api.flickr.com/services/rest/"
        var arguments = arguments
        arguments["method"] = endpoint
        var urlComponents = URLComponents(string: base)
        let queryItems = arguments.map { key, value in return URLQueryItem(name: key, value: value) }
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    func getRequest(url: URL, completion: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.url = url
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
            } else if let data = data {
                completion(data)
            }
        }
        task.resume()
    }
}
