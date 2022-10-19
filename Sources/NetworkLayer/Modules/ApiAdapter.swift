//
//  ApiAdapter.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation
import Alamofire

final public class ApiAdapter: RequestAdapter {
    private let accessProvider: AccessProviderProtocol
    
    public init(accessProvider: AccessProviderProtocol) {
        self.accessProvider = accessProvider
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        /*
         at this part of the code, we add access token into http request header to manage interceptor layer in networking
         */
        
        let currentUrl = urlRequest.url?
            .appending("ts", value: accessProvider.returnUniqueData())
            .appending("apikey", value: accessProvider.returnApiKey())
            .appending("hash", value: accessProvider.returnHash())
        
        guard let url = currentUrl else {
            completion(.success(urlRequest))
            return
        }

        completion(.success(URLRequest(url: url)))
    }
}
