//
//  ApiRetrier.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation
import Alamofire

final public class ApiRetrier: RequestRetrier {
    public init() {}
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        guard let task = request.task, let response = task.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }
        
        completion(.doNotRetry)

        switch response.statusCode {
        case 403:
            // direct the application login screen
            print("token refresh is required")
            //completion(.retry)
        default:
            completion(.doNotRetry)

        }
        
    }
}
