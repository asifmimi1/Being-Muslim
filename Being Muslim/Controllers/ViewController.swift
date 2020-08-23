//
//  ViewController.swift
//  Being Muslim
//
//  Created by Asif's Mac on 22/8/20.
//  Copyright © 2020 Asif's Mac. All rights reserved.
//

import UIKit
import Adhan

class ViewController: UIViewController {
    
    @IBOutlet weak var NextNamajLbl: UILabel!
    @IBOutlet weak var ArabicDateLbl: UILabel!
    @IBOutlet weak var EnglishDateLbl: UILabel!
    @IBOutlet weak var FajarLbl: UILabel!
    @IBOutlet weak var DhuhrLbl: UILabel!
    @IBOutlet weak var AsrLbl: UILabel!
    @IBOutlet weak var MaghribLbl: UILabel!
    @IBOutlet weak var IshaLbl: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        AdhanLibrary()
        EngDate()
        ArabicDate()
        
    }
    
    
    
    func ArabicDate() {
        let formetter = DateFormatter()
        let islamicCelender: Calendar = Calendar(identifier: .islamicCivil)
        formetter.dateFormat = "d MMMM, yyyy"
        let currentDate: Date = Date()
        formetter.calendar = islamicCelender
        let hijriDate = formetter.string(from: currentDate)
        ArabicDateLbl.text = hijriDate
    }
    func EngDate() {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE,d MMM, yyyy"
        let exactlyCurrentTime: Date = Date()
        print(dateFormatterPrint.string(from: exactlyCurrentTime))
        EnglishDateLbl.text = "\(dateFormatterPrint.string(from: exactlyCurrentTime))"
    }
    
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
            
            print("fajr \(formatter.string(from: prayers.fajr))")
            print("sunrise \(formatter.string(from: prayers.sunrise))")
            print("dhuhr \(formatter.string(from: prayers.dhuhr))")
            print("asr \(formatter.string(from: prayers.asr))")
            print("maghrib \(formatter.string(from: prayers.maghrib))")
            print("isha \(formatter.string(from: prayers.isha))")
        
            FajarLbl.text = formatter.string(from: prayers.fajr)
            DhuhrLbl.text = formatter.string(from: prayers.dhuhr)
            AsrLbl.text = formatter.string(from: prayers.asr)
            MaghribLbl.text = formatter.string(from: prayers.maghrib)
            IshaLbl.text = formatter.string(from: prayers.isha )
            
            
            let prayerTimes = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)

            let current = prayerTimes?.currentPrayer()
            let next = prayerTimes?.nextPrayer()
            let countdown = prayerTimes!.time(for: next!)
            NextNamajLbl.text = formatter.string(from: countdown)
            }
    }
    
}

