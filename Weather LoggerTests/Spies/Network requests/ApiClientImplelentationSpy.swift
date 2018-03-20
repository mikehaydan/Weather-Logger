//
//  ApiClientImplelentationSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 19/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
@testable import Weather_Logger

class ApiClientImplelentationSpy: ApiClient {
    typealias URLSessionCompletionHandlerResponse = (data: Data?, response: URLResponse?, error: Error?)
    
    private let urlSession: UrlSessionStub
    
    init() {
        let session = UrlSessionStub()
        urlSession = session
    }
    
    func set(response: URLSessionCompletionHandlerResponse) {
        urlSession.response.append(response)
    }
    
    func execute<T>(request: ApiRequest, completion: @escaping (_ result: Result<ApiResponse<T>>) -> ()) {
        let dataTask = urlSession.dataTask(with: request.urlRequest, completionHandler: { (data, response, error) in
            guard let httpUrlresponse = response as? HTTPURLResponse else {
                completion(Result.failure(NetworkRequestError(error: error)))
                return
            }
            let successRange = 200...299
            if successRange.contains(httpUrlresponse.statusCode) {
                do {
                    let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlresponse)
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(error))
                }
            } else {
                let error = StatusCodeError(data: data, httpUrlResponse: httpUrlresponse)
                completion(Result.failure(error))
            }
        })
        
        dataTask.resume()
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "https://www.google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
