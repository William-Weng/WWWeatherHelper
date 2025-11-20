//
//  Constant.swift
//  WWWeatherHelper
//
//  Created by William.Weng on 2025/11/20.
//

import Foundation

public extension WWWeatherHelper {
    
    /// 自訂錯誤
    enum CustomError: Error, LocalizedError {
        
        var errorDescription: String { errorMessage() }
        
        case unknown
        case notOpenURL
        case unregistered
        
        /// 顯示錯誤說明
        /// - Returns: String
        private func errorMessage() -> String {
            
            switch self {
            case .unknown: return "未知錯誤"
            case .notOpenURL: return "打開URL錯誤"
            case .unregistered: return "尚未註冊"
            }
        }
    }
}
