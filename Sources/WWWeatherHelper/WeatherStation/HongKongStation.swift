//
//  HongKongStation.swift
//  WWWeatherHelper
//
//  Created by William.Weng on 2025/11/24.
//

import Foundation
import WWNetworking

// MARK: - 香港天文台開放數據 (天氣)
extension WWWeatherHelper.HongKongStation {
    
    /// [取得API數據](https://www.hko.gov.hk/tc/weatherAPI/doc/files/HKO_Open_Data_API_Documentation_tc.pdf)
    /// - Parameters:
    ///   - lang: [支援語系](https://miteen.hk/share/HKO_eservices/)
    ///   - dataType: [數據資料類型](https://www.hko.gov.hk/textonly/v2/explain/wxicon_c.htm)
    ///   - result: Result<[String: Any], Error>
    func information(lang: Language, dataType: DataType, result: @escaping ((Result<[String: Any], Error>) -> Void)) {
        
        let parameters = [
            "dataType": "\(dataType)",
            "lang": "\(lang)",
        ]
        
        _ = WWNetworking.shared.request(urlString: apiURL, paramaters: parameters) { _result_ in
            switch _result_ {
            case .failure(let error): result(.failure(error))
            case .success(let info):
                
                guard let data = info.data,
                      let dict = data._jsonSerialization() as? [String: Any]
                else {
                    return result(.failure(WWWeatherHelper.CustomError.jsonEmpty))
                }
                
                result(.success(dict))
            }
        }
    }
}
