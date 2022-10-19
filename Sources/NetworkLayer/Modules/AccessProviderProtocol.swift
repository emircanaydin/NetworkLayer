//
//  File.swift
//  
//
//  Created by Emircan Aydın on 14.09.2021.
//

import Foundation

public protocol AccessProviderProtocol {
    func returnUniqueData() -> String
    func returnApiKey() -> String
    func returnHash() -> String
}
