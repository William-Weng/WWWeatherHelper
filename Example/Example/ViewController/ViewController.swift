//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//

import UIKit
import CoreLocation
import WWWeatherHelper

final class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        WWWeatherHelper.shared.configure(appId: "<appId>")
    }
    
    @IBAction func weatherInformationForCity(_ sender: UIButton) { weatherInformationForCity() }
    @IBAction func infoForCoordinate(_ sender: UIButton) { weatherInformationForCoordinate2D() }
}

// MARK: - ViewController (private class function)
extension ViewController {
    
    /// 取得該城市的天氣資訊
    private func weatherInformationForCity() {
        
        view.endEditing(true)
        
        guard let cityName = cityNameTextField.text else { self.displayText(WWWeatherHelper.CustomError.unknown); return }
        
        WWWeatherHelper.shared.information(with: cityName) { result in
            switch result {
            case .failure(let error): self.displayText(error)
            case .success(let info): self.displayText(info.data?._jsonSerialization())
            }
        }
    }
    
    /// 取得該坐標的天氣資訊
    private func weatherInformationForCoordinate2D() {
        
        view.endEditing(true)
        
        guard let latitudeText = latitudeTextField.text,
              let longitudeText = longitudeTextField.text,
              let latitude = Double(latitudeText),
              let longitude = Double(longitudeText),
              let coordinate2D = Optional.some(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        else {
            self.displayText(WWWeatherHelper.CustomError.unknown); return
        }
        
        WWWeatherHelper.shared.information(with: coordinate2D) { result in
            switch result {
            case .failure(let error): self.displayText(error)
            case .success(let info): self.displayText(info.data?._jsonSerialization())
            }
        }
    }
    
    /// 顯示文字
    /// - Parameter text: Any?
    private func displayText(_ text: Any?) {
        
        guard let text = text else { return }
        DispatchQueue.main.async { self.resultTextView.text = "\(text)" }
    }
}

// MARK: - Data (class function)
extension Data {
    
    /// Data => JSON
    /// - 7b2268747470223a2022626f6479227d => {"http": "body"}
    /// - Returns: Any?
    func _jsonSerialization(options: JSONSerialization.ReadingOptions = .allowFragments) -> Any? {
        let json = try? JSONSerialization.jsonObject(with: self, options: options)
        return json
    }
}

