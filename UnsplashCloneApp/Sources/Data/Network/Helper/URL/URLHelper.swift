//
//  URLHelper.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import Foundation

struct URLHelper {
    static func createEncodedURL(url : String?) -> URL? {
        guard let url = url?.trimmed,
              url.count > 0,
              let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let returnURL = URL(string: encodedURL) else {
            print("url error!! \(url ?? "")")
            return nil
        }
        
        return returnURL
    }
    
    static func createPath(
        baseURL: String,
        queryItems: [URLQueryItem]?
    ) -> URL {
        var components = URLComponents(string: baseURL.trimmed)
        let totalQueryItems = (components?.queryItems ?? []) + (queryItems ?? [])
        components?.queryItems = totalQueryItems
        guard let url = components?.url else { return URL(string: baseURL)! }
        return url
    }
    
    static func createAbsolutePath(
        baseURL: String,
        queryItems: [URLQueryItem]?
    ) -> String {
        return URLHelper.createPath(
            baseURL: baseURL,
            queryItems: queryItems
        ).absoluteString
    }
}

