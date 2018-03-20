//
//  Result.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation

@testable import Weather_Logger

extension Result: Equatable { }

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
}
