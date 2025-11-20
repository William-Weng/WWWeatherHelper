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
    
    public static let shared = WWWeatherHelper()
    
    private let apiURL = "https://api.openweathermap.org/data/2.5/weather"
    private(set) var appId: String?

    private override init() {}
}

// MARK: - WWWeatherHelper (public function)
public extension WWWeatherHelper {
    
    /// [初始化設定](https://home.openweathermap.org/api_keys)
    /// - Parameters:
    ///   - appId: [開發者註冊的AppId](https://medium.com/彼得潘的-swift-ios-app-開發教室/ios-weather-app-part1-申請api-key-解析json-3a90f41dbf68)
    func configure(appId: String) {
        self.appId = appId
    }
    
    /// [根據『城市名稱』取得氣候的相關數值](https://openweathermap.org/api)
    /// - Parameters:
    ///   - cityName: 城市名稱 => Taipei
    ///   - result: Result<Information, Error>
    func information(cityName: String, result: @escaping (Result<Information, Error>) -> Void) {
        
        guard let appId = self.appId else { result(.failure(CustomError.unregistered)) ;return }

        informationWithCityName(cityName, appId: appId) { _result in
            
            switch _result {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(.success(info))
            }
        }
    }
    
    /// [根據『2D坐標』取得氣候的相關數值](https://blog.csdn.net/weixin_44929101/article/details/132624712)
    /// - Parameters:
    ///   - coordinate: 坐標 => (25.0178, 121.5211)
    ///   - result: Result<Information, Error>
    func information(coordinate: CLLocationCoordinate2D, result: @escaping (Result<Information, Error>) -> Void) {
        
        guard let appId = self.appId else { result(.failure(CustomError.unregistered)) ;return }
        
        informationWithCoordinate(coordinate, appId: appId) { _result in
            
            switch _result {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(.success(info))
            }
        }
    }
}

// MARK: - WWWeatherHelper (public function)
public extension WWWeatherHelper {
 
    /// [根據『城市名稱』取得氣候的相關數值](https://openweathermap.org/api)
    /// - Parameters:
    ///   - cityName: 城市名稱 => Taipei
    /// - Returns: Result<Information, Error>
    func information(cityName: String) async -> Result<Information, Error> {
        
        await withCheckedContinuation { continuation in
            information(cityName: cityName) { continuation.resume(returning: $0)  }
        }
    }
    
    /// 根據『2D坐標』取得氣候的相關數值
    /// - Parameters:
    ///   - coordinate: 坐標 => (25.0178, 121.5211)
    /// - Returns: Result<Information, Error>
    func information(coordinate: CLLocationCoordinate2D) async -> Result<Information, Error> {
        
        await withCheckedContinuation { continuation in
            information(coordinate: coordinate) { continuation.resume(returning: $0)  }
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
    ///   - result: Result<Information, Error>
    func informationWithCityName(_ cityName: String, appId: String, units: String = "metric", result: @escaping (Result<Information, Error>) -> Void) {
        
        let this = self
        
        let paramaters = [
            "appid": appId,
            "q": cityName,
            "units": units
        ]
        
        WWNetworking.shared.request(urlString: apiURL, paramaters: paramaters) { _result_ in
            switch _result_ {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(this.parseResponseInformation(info))
            }
        }
    }
    
    /// 根據『2D坐標』取得氣候的相關數值
    /// - Parameters:
    ///   - coordinate: 坐標 => (25.0178, 121.5211)
    ///   - appId: 開發者註冊的AppId
    ///   - units: 溫度單位 => 攝氏 (metric)
    ///   - result: Result<Information, Error>
    func informationWithCoordinate(_ coordinate: CLLocationCoordinate2D, appId: String, units: String = "metric", result: @escaping (Result<Information, Error>) -> Void) {
        
        let this = self
        
        let paramaters = [
            "appid": appId,
            "lat": "\(coordinate.latitude)",
            "lon": "\(coordinate.longitude)",
            "units": units
        ]
                
        WWNetworking.shared.request(urlString: apiURL, paramaters: paramaters) { _result_ in
            switch _result_ {
            case .failure(let error): result(.failure(error))
            case .success(let info): result(this.parseResponseInformation(info))
            }
        }
    }
    
    /// 解析API回傳資訊
    /// - Parameter info: WWNetworking.ResponseInformation
    /// - Returns: Result<Information, Error>
    func parseResponseInformation(_ info: WWNetworking.ResponseInformation) -> Result<Information, Error> {
        
        guard let response = info.response else { return .failure(CustomError.unknown) }
        
        let statusCode = response.statusCode
                
        if ((statusCode / 100) != 2) { return .failure(CustomError.statusError(statusCode)) }
        
        if let jsonObject = info.data?._jsonSerialization() as? [String: Any] { return .success(Information(jsonObject, statusCode)) }
        return .failure(CustomError.notJSONData)
    }
}
