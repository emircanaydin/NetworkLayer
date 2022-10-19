//
//  HttpHeaderFields.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation
import Alamofire

public enum HTTPHeaderFields {
    case contentType
    
    var value: HTTPHeader {
        switch self {
        case .contentType:
            return HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8")
        }
    }
}
