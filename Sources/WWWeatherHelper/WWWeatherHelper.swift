//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//

import UIKit
import CoreLocation
import WWNetworking

// MARK: - [WWWeatherHelper - OpenWeatherMap => $$$](https://openweathermap.org/)
open class WWWeatherHelper: NSObject {
    
    /// 自訂錯誤
    public enum MyError: Error, LocalizedError {
        
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
    
    public static let shared = WWWeatherHelper()
    
    private(set) var appId: String?
    private(set) var apiURL = "https://api.openweathermap.org/data/2.5/weather"

    private override init() {}
}

// MARK: - WWWeatherHelper (public function)
public extension WWWeatherHelper {
    
    /// [初始化設定](https://home.openweathermap.org/api_keys)
    /// - Parameters:
    ///   - appId: [開發者註冊的AppId](https://medium.com/彼得潘的-swift-ios-app-開發教室/ios-weather-app-part1-申請api-key-解析json-3a90f41dbf68)
    ///   - apiURL: [API的URL => v2.5](https://openweathermap.org/api)
    func configure(appId: String, apiURL: String = "https://api.openweathermap.org/data/2.5/weather") {
        self.appId = appId
        self.apiURL = apiURL
    }
    
    /// 根據『城市名稱』取得氣候的相關數值
    /// - Parameters:
    ///   - cityName: 城市名稱 => Taipei
    /// - Returns: Result<Data?, Error>
    func information(with cityName: String, result: @escaping (Result<WWNetworking.ResponseInformation, Error>) -> Void) {
        
        guard let appId = self.appId else { result(.failure(MyError.unregistered)) ;return }

        informationWithCityName(cityName, appId: appId) { _result in
            
            switch _result {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(.success(info))
            }
        }
    }
    
    /// 根據『2D坐標』取得氣候的相關數值
    /// - Parameters:
    ///   - coordinate: 坐標 => (25.0178, 121.5211)
    /// - Returns: Result<Data?, Error>
    func information(with coordinate: CLLocationCoordinate2D, result: @escaping (Result<WWNetworking.ResponseInformation, Error>) -> Void) {
        
        guard let appId = self.appId else { result(.failure(MyError.unregistered)) ;return }
        
        informationWithCoordinate(coordinate, appId: appId) { _result in
            
            switch _result {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(.success(info))
            }
        }
    }
}

// MARK: - WWWeatherHelper (private function)
private extension WWWeatherHelper {
    
    /// 根據『城市名稱』取得氣候的相關數值
    /// => https://api.openweathermap.org/data/2.5/weather?q=<CityName>&appid=<appId>&units=metric
    /// - Parameters:
    ///   - cityName: 城市名稱 => Taipei
    ///   - appId: 開發者註冊的AppId
    ///   - units: 溫度單位 => 攝氏 (metric)
    ///   - result: Result<WWNetworking.ResponseInformation, Error>
    func informationWithCityName(_ cityName: String, appId: String, units: String = "metric", result: @escaping (Result<WWNetworking.ResponseInformation, Error>) -> Void) {
                        
        let paramaters = [
            "appid": appId,
            "q": cityName,
            "units": units
        ]
        
        WWNetworking.shared.request(with: .GET, urlString: apiURL, contentType: .plain, paramaters: paramaters, headers: nil, httpBody: nil) { _result in
            switch _result {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(.success(info))
            }
        }
    }
    
    /// 根據『2D坐標』取得氣候的相關數值
    /// - Parameters:
    ///   - coordinate: 坐標 => (25.0178, 121.5211)
    ///   - appId: 開發者註冊的AppId
    ///   - units: 溫度單位 => 攝氏 (metric)
    ///   - result: Result<WWNetworking.ResponseInformation, Error>
    func informationWithCoordinate(_ coordinate: CLLocationCoordinate2D, appId: String, units: String = "metric", result: @escaping (Result<WWNetworking.ResponseInformation, Error>) -> Void) {
        
        let paramaters = [
            "appid": appId,
            "lat": "\(coordinate.latitude)",
            "lon": "\(coordinate.longitude)",
            "units": units
        ]
        
        WWNetworking.shared.request(with: .GET, urlString: apiURL, contentType: .plain, paramaters: paramaters, headers: nil, httpBody: nil) { _result in
            switch _result {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(.success(info))
            }
        }
    }
}
