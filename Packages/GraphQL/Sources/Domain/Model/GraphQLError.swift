//
//  GraphQLError.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation

public enum GraphQLError: Error {
    case gqlError(errors: [Error])
    case networkError(error: Error)
    case unknownError
}
