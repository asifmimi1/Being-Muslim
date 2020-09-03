//
//  ViewController.swift
//  Being Muslim
//
//  Created by Asif's Mac on 22/8/20.
//  Copyright © 2020 Asif's Mac. All rights reserved.
//

import UIKit
import Adhan

class HomeVC: UIViewController {
    
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
            
            
            let prayerTimes = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)
            
            //            let next = prayerTimes?.nextPrayer()
            //            let countdown = prayerTimes!.time(for: next!)
            //            NextNamajLbl.text = formatter.string(from: countdown)
            
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

