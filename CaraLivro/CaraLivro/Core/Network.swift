//
//  Network.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 07/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation

let stringURL = "http://192.168.100.100:3000/"

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
