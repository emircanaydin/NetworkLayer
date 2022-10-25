//
//  ApiManager.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation
import Alamofire
import RxSwift
import NetworkEntityLayer

final public class ApiManager: ApiManagerProtocol {
    // MARK: - To manage Alamofire requests -
    private var session = Session()

    // MARK: - To decode JSON response -
    private var jsonDecoder = JSONDecoder()
    
    public init(interceptor: ApiInterceptor, eventMonitors: ApiEventMonitor) {

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 60
        configuration.requestCachePolicy = .reloadIgnoringCacheData
    
        session = Session(configuration: configuration, startRequestsImmediately: true, interceptor: interceptor, eventMonitors: [eventMonitors])
        session.serverTrustManager?.allHostsMustBeEvaluated = false
    }
    
    public func executeRequest<R>(urlRequestConvertible: URLRequestConvertible) -> Single<R> where R : Decodable, R : Encodable {
        return Single.create { [weak self] (single) -> Disposable in

            self?.session.request(urlRequestConvertible).validate().response(completionHandler: { (alamofireResponseData) in
                self?.responseParser(alamofireResponseData: alamofireResponseData, single: single)
            })

            return Disposables.create()
        }
    }
    
    public func responseParser<R>(alamofireResponseData: AFDataResponse<Data?>, single: (SingleEvent<PrimitiveSequence<SingleTrait, R>.Element>) -> Void) where R : Decodable, R : Encodable {
        switch alamofireResponseData.result {
        case .failure(_):

            if let data = alamofireResponseData.data {
                do {
                    // server side returns logical business error message
                    let dataDecoded = try jsonDecoder.decode(ServerResponse.self, from: data)
                    single(.failure(ErrorResponse(serverResponse: dataDecoded, apiConnectionErrorType: .serverError(self.returnStatusCode(data: alamofireResponseData)))))
                } catch _ {
                    // unacceptable status codes, data can not be decoded such as internal server errors 500 etc...
                    single(.failure(ErrorResponse(apiConnectionErrorType: .missingData(self.returnStatusCode(data: alamofireResponseData)))))
                }
            } else {
                // In the circumstances the client can not reach server side, there is no data can be decoded. For instance time out cases.
                single(.failure(ErrorResponse(apiConnectionErrorType: .connectionError(self.returnStatusCode(data: alamofireResponseData)))))
            }
        case .success(let data):
            if let data = data {

                do {
                    let dataDecoded = try jsonDecoder.decode(R.self, from: data)
                    single(.success(dataDecoded))
                } catch let error {
                    single(.failure(ErrorResponse(apiConnectionErrorType: .dataDecodedFailed(error.localizedDescription))))
                }
            }
        }
    }
    
    private func returnStatusCode(data: AFDataResponse<Data?>) -> Int {
        guard let response = data.response else { return 0 }
        return response.statusCode
    }

    private func returnErrorCode(error: AFError) -> Int {
        guard let underlyingError = error.underlyingError else { return NSURLErrorUnknown }
        return underlyingError._code
    }
}
