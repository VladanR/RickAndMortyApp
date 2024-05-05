//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Vladan Ranđelović on 2/21/23.
//

import Foundation

final class RMAPICacheManager {
    
    private var cacheDictionary: [
        RMEndpoints: NSCache<NSString, NSData>
    ] = [:]
    
    private var cache = NSCache<NSString, NSData>()
    
    init() {
        setupCache()
    }
    
    public func cachedResponse(for endpoint: RMEndpoints, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoints, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    private func setupCache() {
        RMEndpoints.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
