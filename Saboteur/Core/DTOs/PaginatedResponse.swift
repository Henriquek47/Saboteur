//
//  PaginatedResponse.swift
//  Saboteur
//

import Foundation

struct PaginatedResponse<T: Decodable>: Decodable {
  let items: [T]
  let total: Int
  let page: Int
  let pageSize: Int
  let totalPages: Int

  enum CodingKeys: String, CodingKey {
    case items
    case total
    case page
    case pageSize = "page_size"
    case totalPages = "total_pages"
  }
}
