//
//  NetworkManager.swift
//  PaginationAssesment
//
//  Created by Avaneesh Kumar on 26/04/24.
//

import Foundation

class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    private init() {}
    
    func fetchPosts(page: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)?_page=\(page)&_limit=10"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
}
