//
//  RMService.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/17/23.
//

import Foundation


/// API service to connect to Rick And Morty API
final class RMService {
    
    /// Singleton instance
    static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Sending a request to Rick And Morty API to get data
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: Type of object in response
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(_ request: RMAPIRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            do {
                let response = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(response))
            }
            catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self]
            data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(response))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    private func request(from rmRequest: RMAPIRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMehtod
        
        return request
    }
}
