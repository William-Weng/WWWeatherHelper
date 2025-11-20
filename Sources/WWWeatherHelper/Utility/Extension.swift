//
//  Extension.swift
//  WWWeatherHelper
//
//  Created by William.Weng on 2025/11/20.
//

import Foundation

// MARK: - Data (class function)
extension Data {
    
    /// Data => JSON
    /// - 7b2268747470223a2022626f6479227d => {"http": "body"}
    /// - Returns: Any?
    func _jsonSerialization(options: JSONSerialization.ReadingOptions = .allowFragments) -> Any? {
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: options)
        return jsonObject
    }
}
