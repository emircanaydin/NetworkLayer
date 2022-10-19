//
//  ApiEventMonitor.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//


import Foundation
import Alamofire

/// Description: It's used for tracking events going through network layer
final public class ApiEventMonitor: EventMonitor {
    public init() {}
    
    public func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {

    }

    public func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {

    }
}
