//
//  PointData.swift
//  Saboteur
//
//  Created by Henrique Lima on 03/05/26.
//

import Foundation

struct PointData: Identifiable, Codable {
    var id: String { "\(category)-\(day)" }
    let day: String
    let points: Int
    let category: String
}
