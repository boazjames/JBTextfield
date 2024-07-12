//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import Foundation

public struct Country: Decodable {
    public var name: String
    public var code: String
    public var dialCode: String
    
    init(name: String, code: String, dialCode: String) {
        self.name = name
        self.code = code
        self.dialCode = dialCode
    }
}
