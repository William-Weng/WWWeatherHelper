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

    private let appId = "<appId>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWWeatherHelper.shared.configure(appId: appId)
    }
    
    @IBAction func weatherInformationForCity(_ sender: UIButton) { weatherInformationForCity() }
    @IBAction func infoForCoordinate(_ sender: UIButton) { weatherInformationForCoordinate2D() }
}

// MARK: - ViewController (private class function)
private extension ViewController {
    
    /// 取得該城市的天氣資訊
    func weatherInformationForCity() {
        
        view.endEditing(true)
        
        guard let cityName = cityNameTextField.text else { self.displayText(WWWeatherHelper.CustomError.unknown); return }
        
        WWWeatherHelper.shared.information(cityName: cityName) { result in
            switch result {
            case .failure(let error): self.displayText(error)
            case .success(let info): self.displayText(info.dictionary)
            }
        }
    }
    
    /// 取得該坐標的天氣資訊
    func weatherInformationForCoordinate2D() {
        
        let this = self
        
        view.endEditing(true)
        
        guard let latitudeText = latitudeTextField.text,
              let longitudeText = longitudeTextField.text,
              let latitude = Double(latitudeText),
              let longitude = Double(longitudeText),
              let coordinate2D = Optional.some(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        else {
            self.displayText(WWWeatherHelper.CustomError.unknown); return
        }
        
        WWWeatherHelper.shared.information(coordinate: coordinate2D) { result in
            switch result {
            case .failure(let error): this.displayText(error)
            case .success(let info): this.displayText(info.dictionary)
            }
        }
    }
    
    /// 顯示文字
    /// - Parameter text: Any?
    func displayText(_ text: Any?) {
        
        guard let text = text else { return }
        resultTextView.text = "\(text)"
    }
}
