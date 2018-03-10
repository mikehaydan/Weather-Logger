//
//  Result.swift
//  MVP+Tests
//
//  Created by Mike Haydan on 02/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failure(Error)
}
