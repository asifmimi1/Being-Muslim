//
//  ViewController.swift
//  Being Muslim
//
//  Created by Asif's Mac on 22/8/20.
//  Copyright © 2020 Asif's Mac. All rights reserved.
//

import UIKit
import Adhan
import Alamofire
import SwiftyJSON
import CoreLocation

class HomeVC: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "d1abad9493addf56c008594bc9db25cc"
    @IBOutlet weak var cityLocationLbl: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var NextNamazLbl: UILabel!
    
    @IBOutlet weak var FajarNamazView: UIView!
    @IBOutlet weak var DhuhrNamazView: UIView!
    @IBOutlet weak var AsrNamazView: UIView!
    @IBOutlet weak var MaghribNamazView: UIView!
    @IBOutlet weak var IshaNamazView: UIView!
    
    @IBOutlet weak var IftarTimeLbl: UILabel!
    @IBOutlet weak var SahurTimeLbl: UILabel!
    
    @IBOutlet weak var SunriseLbl: UILabel!
    @IBOutlet weak var SunsetLbl: UILabel!
    
    @IBOutlet weak var NextNamajLbl: UILabel!
    
    @IBOutlet weak var ArabicDateLbl: UILabel!
    @IBOutlet weak var EnglishDateLbl: UILabel!
    
    @IBOutlet weak var FajarLbl: UILabel!
    @IBOutlet weak var DhuhrLbl: UILabel!
    @IBOutlet weak var AsrLbl: UILabel!
    @IBOutlet weak var MaghribLbl: UILabel!
    @IBOutlet weak var IshaLbl: UILabel!
    
    //let quranVC = QuranTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        AdhanLibrary()
        EngDate()
        ArabicDate()
        NamazView(demoView: FajarNamazView)
        NamazView(demoView: DhuhrNamazView)
        NamazView(demoView: AsrNamazView)
        NamazView(demoView: MaghribNamazView)
        NamazView(demoView: IshaNamazView)
        //quranVC.parseJSON()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: Arabic date
    func ArabicDate() {
        let formetter = DateFormatter()
        let islamicCelender: Calendar = Calendar(identifier: .islamicCivil)
        formetter.dateFormat = "d MMMM, yyyy"
        let currentDate: Date = Date()
        formetter.calendar = islamicCelender
        let hijriDate = formetter.string(from: currentDate)
        ArabicDateLbl.text = hijriDate
    }
    //MARK: Gegorian date
    func EngDate() {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEE,d MMM, yyyy"
        let exactlyCurrentTime: Date = Date()
        print(dateFormatterPrint.string(from: exactlyCurrentTime))
        EnglishDateLbl.text = "\(dateFormatterPrint.string(from: exactlyCurrentTime))"
    }
    //MARK: 'Adhan' pod
    func AdhanLibrary() {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        let coordinates = Coordinates(latitude: 23.777176, longitude: 90.399452)
        var params = CalculationMethod.moonsightingCommittee.params
        params.madhab = .hanafi
        
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(identifier: "Asia/Dhaka")!
            formatter.locale = Locale(identifier: "bn_IN")
            
            FajarLbl.text = formatter.string(from: prayers.fajr)
            DhuhrLbl.text = formatter.string(from: prayers.dhuhr)
            AsrLbl.text = formatter.string(from: prayers.asr)
            MaghribLbl.text = formatter.string(from: prayers.maghrib)
            IshaLbl.text = formatter.string(from: prayers.isha )
            
            SunriseLbl.text = formatter.string(from: prayers.sunrise)
            SunsetLbl.text = formatter.string(from: prayers.maghrib)
            
            SahurTimeLbl.text = formatter.string(from: prayers.fajr)
            IftarTimeLbl.text = formatter.string(from: prayers.maghrib)
            
            let nyc = Coordinates(latitude: 40.7128, longitude: -74.0059)
            let qiblaDirection = Qibla(coordinates: nyc).direction
            print("\n Qibla: \(qiblaDirection)")
            
            
            let prayerTimes = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)
        
            let next = prayerTimes?.nextPrayer()
            if next != nil{
                let countdown = prayerTimes!.time(for: next!)
                NextNamajLbl.text = formatter.string(from: countdown)
            }else{
                NextNamajLbl.isHidden = true
                NextNamazLbl.isHidden = true
            }
        }
    }
    
    func NamazView(demoView: UIView) {
        demoView.layer.borderWidth = 1
        demoView.layer.borderColor = UIColor.white.cgColor
        demoView.layer.cornerRadius = 8
    }
    
    
    
}

//MARK: Location Manager setup
extension HomeVC{
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : lat , "lon" : lon, "appid" : APP_ID]
            print(params)
            getWeatherData(url: WEATHER_URL, parameter: params)
        }
    }
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can't find the location ERROR: \(error)")
        cityLocationLbl.text = "Dhaka"
    }
    //MARK: - Change City Delegate methods
    func changeCityName(searchCityName: String) {
        print(searchCityName)
        let params : [String : String] = ["q" : searchCityName, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameter: params)
    }
    
    //MARK: - Networking with Alamofire
    //Write the getWeatherData method here:
    func getWeatherData(url : String, parameter : [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameter).responseJSON {
            response in
            if response.result.isSuccess{
                print("Ntetworking Successful")
                let jsonData : JSON = JSON(response.result.value!)
                print("JSON DATA:\(jsonData)")
                self.weatherData(data: jsonData)
                self.updateUIView()
            }
            else{
                print("Error Getting JSON response : \(response.result.error!)")
            }
        }
    }
    
    //MARK: - JSON Parsing
    func weatherData(data : JSON) {
        let tempResult = data["main"]["temp"].doubleValue
        weatherDataModel.Temperature = Int(tempResult - 273.15)
        weatherDataModel.CityId = data["weather"]["0"]["id"].intValue
        weatherDataModel.CityName = data["name"].stringValue
        weatherDataModel.WeatherIcon = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.CityId)
    }
    //MARK: - UI Updates
    func updateUIView() {
        cityLocationLbl.text = weatherDataModel.CityName
        print(weatherDataModel.CityName)
        temperatureLabel.text = String(weatherDataModel.Temperature)
        //weatherIcon.image = UIImage(named: weatherDataModel.WeatherIcon)
    }

}
