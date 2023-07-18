//
//  ApiServiceProvider.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation
import Alamofire

open class ApiServiceProvider<T: Codable>: URLRequestConvertible {
    private var baseUrl: String
    private var method: HTTPMethod
    private var path: String?
    private var isAuthRequested: Bool
    private var data: T?
    
    /// Description: General Api call service provider. It's create a urlRequestConvertible object to pass as an argument to alamofire url session request
    /// - Parameters:
    ///   - method: http methods, default value is get
    ///   - path: url path, default value is nil
    ///   - isAuthRequested: it's used to pass accessToken to header or not. Default value is true
    ///   - data: Codable data. If request is post, patch or put it's used as body otherwise as query string
    public init(baseUrl: String, method: HTTPMethod = .get, path: String? = nil, isAuthRequested: Bool = true, data: T? = nil) {
        self.baseUrl = baseUrl
        self.method = method
        self.path = path
        self.isAuthRequested = isAuthRequested
        self.data = data
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url = try baseUrl.asURL()
        
        if let path = path {
            url = url.appendingPathComponent(path)
        }
         
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.headers = headers
        request.cachePolicy = .reloadIgnoringCacheData
        
        return try encoding.encode(request, with: params)
        
    }
    
    public func addHeader(header: HTTPHeader) {
        headers.add(header)
    }
    
    // MARK: - Encoding -
    private var encoding: ParameterEncoding {
        switch method {
        case .post, .patch, .put:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
    
    private var params: Parameters? {
        return data.asDictionary()
    }

    private var headers: HTTPHeaders = {
        var httpHeaders = HTTPHeaders()
        httpHeaders.add(HTTPHeaderFields.contentType.value)
        return httpHeaders
    }()
}
