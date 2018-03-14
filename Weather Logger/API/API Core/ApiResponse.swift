//
//  ApiResponse.swift
//  MVP+Tests
//
//  Created by Mike Haydan on 02/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

protocol InitializableWithData {
    init(data: Data?) throws
}

protocol InitializableWithJson {
    init(json: [String: Any]) throws
}

struct ApiResponse<T: InitializableWithData> {
    let model: T
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        do {
            self.model = try T(data: data)
            self.httpUrlResponse = httpUrlResponse
            self.data = data
        } catch {
            throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
}

extension Array: InitializableWithData {
    init(data: Data?) throws {
        guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data), let jsonArray = jsonObject as? [[String: Any]] else {
            throw NSError.parseError
        }
       
        guard let element = Element.self as? InitializableWithJson.Type else {
            throw NSError.parseError
        }
        
        self = try jsonArray.map({ return try element.init(json: $0) as! Element })
    }
}

extension NSError {
    class var parseError: NSError {
        return NSError(domain: "com.Mike.App", code: ApiParseError.code, userInfo: [NSLocalizedDescriptionKey: "A parsing error occupted"])
    }
}
