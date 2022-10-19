//
//  File.swift
//  
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation

extension URL {
    func appending(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        guard let value = value, value != "" else {
            return urlComponents.url!
        }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)

        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
