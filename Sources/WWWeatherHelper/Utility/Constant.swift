//
//  Constant.swift
//  WWWeatherHelper
//
//  Created by William.Weng on 2025/11/20.
//

import Foundation

// MARK: - typealias
public extension WWWeatherHelper {
    
    typealias Information = (dictionary: [String: Any], statusCode: Int)    // (天氣資訊, HTTP碼)
}

// MARK: - enum
public extension WWWeatherHelper {
    
    /// 自訂錯誤
    enum CustomError: Error, LocalizedError {
        
        var errorDescription: String { errorMessage() }
        
        case unknown
        case notOpenURL
        case notJSONData
        case unregistered
        case statusError(_ code: Int)
        
        /// 顯示錯誤說明
        /// - Returns: String
        private func errorMessage() -> String {
            
            switch self {
            case .unknown: return "未知錯誤"
            case .notOpenURL: return "打開URL錯誤"
            case .notJSONData: return "非JSON格式的資料"
            case .unregistered: return "尚未註冊"
            case .statusError(let code): return String(format: "HTTP Status Code: %d", code)
            }
        }
    }
}
