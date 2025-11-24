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
        case jsonEmpty
        case statusError(_ code: Int)
        
        /// 顯示錯誤說明
        /// - Returns: String
        private func errorMessage() -> String {
            
            switch self {
            case .unknown: return "未知錯誤"
            case .notOpenURL: return "打開URL錯誤"
            case .notJSONData: return "非JSON格式的資料"
            case .unregistered: return "尚未註冊"
            case .jsonEmpty: return "JSON資料為空"
            case .statusError(let code): return String(format: "HTTP Status Code: %d", code)
            }
        }
    }
}

// MARK: - enum
public extension WWWeatherHelper {
    
    /// 氣象觀測站類型
    enum StationType {
        case HongKong(lang: HongKongStation.Language = .tc, dataType: HongKongStation.DataType = .rhrread)  // 香港天文台
    }
}

// MARK: - 香港天文台開放數據
public extension WWWeatherHelper.HongKongStation {
    
    /// 支援語言
    enum Language: String {
        case en                 // 英文
        case tc                 // 繁體中文
        case sc                 // 簡體中文
    }
    
    /// 資料類型
    enum DataType: String {
        case flw                // 本港地區天氣預報
        case fnd                // 九天天氣預報
        case rhrread            // 本港地區天氣報告
        case warnsum            // 天氣警告一覽
        case warningInfo        // 詳細天氣警告資訊
        case swt                // 特別天氣提示
    }
}
