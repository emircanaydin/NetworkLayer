//
//  HttpClientInterface.swift
//  NetworkLayer
//
//  Created by Emircan Aydın on 14.09.2021.
//


import Foundation
import RxSwift
import Alamofire

public protocol ApiManagerProtocol {
    func executeRequest<R: Codable>(urlRequestConvertible: URLRequestConvertible) -> Single<R>
    func responseParser<R: Codable>(alamofireResponseData: AFDataResponse<Data?>, single: Single<R>.SingleObserver)
}
