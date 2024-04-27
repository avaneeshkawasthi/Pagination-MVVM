//
//  ScreenViewModel.swift
//  PaginationAssesment
//
//  Created by Avaneesh Kumar on 26/04/24.
//

import Foundation

class PostViewModel {
    
    var posts: [Post] = []
    var currentPage = 1
    var isLoading = false
    
    private var computedResults: [Int: Any] = [:]
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        NetworkManager.shared.fetchPosts(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            defer { self.isLoading = false }
            switch result {
            case .success(let newPosts):
                self.posts.append(contentsOf: newPosts)
                completion(.success(newPosts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func computeHeavyTask(for post: Post, completion: @escaping (Any) -> Void) {
        let startTime = DispatchTime.now()
        if let cachedResult = computedResults[post.id] {
            completion(cachedResult)
            return
        }
        
        DispatchQueue.global().async {
            // Perform heavy computation task here
            let heavyResult = "Heavy computation result for post \(post.id)"
            print("Heavy computation task for post \(post.id) completed")
            self.computedResults[post.id] = heavyResult
            
            let endTime = DispatchTime.now()
            let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let elapsedTime = Double(nanoTime) / 1_000_000_000
            
            print("Time taken for heavy computation: \(elapsedTime) seconds")
            DispatchQueue.main.async {
                completion(heavyResult)
            }
        }
     }
 }

