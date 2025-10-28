//
//  BaseResponse.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let meta: Meta
    let data: T?
    let pagination: Pagination?
}

struct Meta: Codable {
    let code: Int
    let errors: [MetaError]?
    let exception: String?
}

struct MetaError: Codable {
    let type: String
    let message: String
}

struct Pagination: Codable {
    // let currentPage: Int?
    // let totalPages: Int?
}
