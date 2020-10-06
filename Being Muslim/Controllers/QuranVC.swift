//
//  QuranVC.swift
//  Being Muslim
//
//  Created by Asif's Mac on 30/8/20.
//  Copyright © 2020 Asif's Mac. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

struct Surah: Decodable {
    let data: Surahs
}
struct Surahs: Codable {
    let surahs: [EnglishName]
}
struct EnglishName: Codable {
    let englishName: String
    let name: String
    let ayahs: [AyahsAudioUrl]
}
struct AyahsAudioUrl: Codable {
    let audio: String
}

class QuranVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var surahName = [EnglishName]()
    var audioUrl = [AyahsAudioUrl]()
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        parseJSON()
    }
    
    //MARK: JSON parse
    func parseJSON()  {
        let url = URL(string: "https://api.alquran.cloud/v1/quran/ar.alafasy")
        
        guard url != nil else{
            print("URL Founr Nill")
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil{
                do{
                    let response = try JSONDecoder().decode(Surah.self, from: data!)
                    self.surahName = response.data.surahs
//                    for i in response.data.surahs{
//                        self.audioUrl = i.
//
//                        print(self.audioUrl)
//                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
            }
            
//            //MARK: URL to Audio
//            let urll = URL(string: "\(self.audioUrl)")
//            self.playerItem = AVPlayerItem(url: urll!)
//            self.player = AVPlayer(playerItem: self.playerItem!)
//
//            let playerLayer = AVPlayerLayer(player: self.player!)
//            //playerLayer = CGRect(x: 0, y: 0, width: 10, height: 50)
//            self.view.layer.addSublayer(playerLayer)
        }.resume()
        
        
    }
    
    //MARK: Tableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surahName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuranAudioCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! QuranAudioCell
        
        let surah = surahName[indexPath.row]
        cell.nameLbl.text = surah.englishName
        cell.arabicNameLbl.text = surah.name
        return cell
    }
    
    //        //MARK: Tableview datasource
    //        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //
    //
    //        }
    
//    @IBAction func audioPlayButton(_ sender: UIButton) {
//        if player?.rate == 0{
//            player?.play()
//            
//        }else{
//            player?.pause()
//        }
//    }
    
    
    
}
