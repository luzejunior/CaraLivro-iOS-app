//
//  Network.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 07/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

let stringURL = "https://shielded-crag-58680.herokuapp.com/"

func getDataFromServer<T: Decodable>(path: String, completion: @escaping (T) -> ()) {
    let urlPath = stringURL + path
    guard let url = URL(string: urlPath) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            let jsonData = try JSONDecoder().decode(T.self, from: data)
            completion(jsonData)
        } catch let jsonErr {
            print(jsonErr.localizedDescription)
        }
        }.resume()
}

func postDataToServer<T: Encodable>(object: T, path: String, completion: @escaping () -> ()) {
    let urlPath = stringURL + path
    guard let url = URL(string: urlPath) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers

    do {
        let jsonData = try JSONEncoder().encode(object)
        request.httpBody = jsonData
    } catch let jsonErr {
        print(jsonErr)
    }

    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            print(responseError!)
            return
        }

        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            print("response: ", utf8Representation)
            completion()
        } else {
            print("no readable data received in response")
        }
    }
    task.resume()
}

func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
    guard let url = URL(string: urlString) else {
        return closure(nil)
    }
    let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
        guard error == nil else {
            print("error: \(String(describing: error))")
            return closure(nil)
        }
        guard response != nil else {
            print("no response")
            return closure(nil)
        }
        guard data != nil else {
            print("no data")
            return closure(nil)
        }
        DispatchQueue.main.async {
            closure(UIImage(data: data!))
        }
    }; task.resume()
}

func uploadImage(image: UIImage?, completion: @escaping (String) -> ()){
    guard let image = image else {
        return;
    }
    
    let dispatchGroup = DispatchGroup()
    let config = CLDConfiguration(cloudName: "dn1glubhp", apiKey: "718496462185294")
    let cloudinary = CLDCloudinary(configuration: config)
    
    dispatchGroup.enter()
    
    let size = CGSize(width: 360, height: 270)
    let imageResized = imageWithImage(image: image, scaledToSize: size)
    let data = UIImagePNGRepresentation(imageResized)
    var url = ""
    cloudinary.createUploader().upload(data: data!, uploadPreset: "presetPamin")
        .response { (result, error) in
            if error == nil {
                // Adiciona link à variavel url
                url = (result?.url)!
                let httpsurl = url.replacingOccurrences(of: "http", with: "https")
                completion(httpsurl)
                dispatchGroup.leave()
            }else{
                print("Erro: \(String(describing: error))")
                dispatchGroup.leave()
            }
    }
    dispatchGroup.notify(queue: .main) {
    }
}

func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}
