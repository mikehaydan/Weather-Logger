//
//  ApiClient.swift
//  MVP+Tests
//
//  Created by Mike Haydan on 02/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

enum HttpMehod: String {
    case get = "GET"
}

protocol ApiRequest {
    var urlRequest: URLRequest { get }
}

protocol ApiClient {
    func execute<T>(request: ApiRequest, completion: @escaping (_ result: Result<ApiResponse<T>>) -> ())
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class ApiClientImplelentation: ApiClient {
    
    private let urlSession: URLSessionProtocol
    
    class var defaultConfiguration: ApiClientImplelentation {
        return ApiClientImplelentation(urlSessionconfiguration: .default, completionQueue: .main)
    }
    
    init(urlSessionconfiguration: URLSessionConfiguration, completionQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionconfiguration, delegate: nil, delegateQueue: completionQueue)
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
