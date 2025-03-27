//
//  NetworkManager.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//

import Foundation

struct NetworkService {
    let urlString: String
    
    func sendRequest(path: String, completion: @escaping (JSONReceiver) -> Void) {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.path = path
        
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {data, _, error in
            guard error == nil, let data = data else { return }
            do {
                let response = try JSONDecoder().decode(JSONReceiver.self, from: data)
                completion(response)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
