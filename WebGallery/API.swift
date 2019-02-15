//
//  API.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class ServerConnection {
    var apiKey = "bbc5efcb126e58a1e6bd0628ce39da6d"
    
    func requestGallery(id: String, completion: @escaping (RequestModel) -> Void) {
        let arguments: [String: String] = ["method": "flickr.galleries.getPhotos",
                                           "api_key": apiKey,
                                           "gallery_id": id,
                                           "format": "json",
                                           "nojsoncallback": "1"]
        if let url = url(endpoint: "flickr.galleries.getPhotos", arguments: arguments) {
            getRequest(url: url, completion: { data in
                let decoder = JSONDecoder()
                do {
                    let gallery = try decoder.decode(RequestModel.self, from: data)
                    completion(gallery)
                } catch {
                    print(error)
                }
            }, failure: { error in
                 print(error)
            })
        }
    }
    
    func requestImage(_ model: ImageModel, size: ImageSize, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://farm\(model.farm).staticflickr.com/\(model.server)/\(model.id)_\(model.secret)_\(size.rawValue).jpg"
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
