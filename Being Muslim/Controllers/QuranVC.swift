//
//  QuranVC.swift
//  Being Muslim
//
//  Created by Asif's Mac on 30/8/20.
//  Copyright © 2020 Asif's Mac. All rights reserved.
//

import UIKit
import Foundation

class QuranVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var surahName = [EnglishName]()
    
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
                    //self.surahName = try JSONDecoder().decode([Surah].self, from: data!)
                    let response = try JSONDecoder().decode(Surah.self, from: data!)
                    self.surahName = response.data.surahs
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    //MARK: Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surahName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuranAudioCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! QuranAudioCell
//        let arrdata = surahName[indexPath.section].data.surahs
//        cell.nameLbl.text = arrdata[indexPath.row].englishName
        let surah = surahName[indexPath.row]
        cell.nameLbl.text = surah.englishName
        return cell
    }
    
    //    //MARK: Tableview datasource
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let surahNumber = indexPath.row + 1
    //    }
    
    
    
}
