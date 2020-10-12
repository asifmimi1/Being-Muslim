//
//  TasbihVCViewController.swift
//  Being Muslim
//
//  Created by Asif's Mac on 6/10/20.
//  Copyright © 2020 Asif's Mac. All rights reserved.
//

import UIKit

class TasbihVCViewController: UIViewController {
    
    @IBOutlet weak var tasbihCountLbl: UILabel!
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        counter += 1
            tasbihCountLbl.text = String(counter)
    }
    
    @IBAction func newCountButton(_ sender: UIButton) {
        if (counter >= 0){
            counter = 0
            tasbihCountLbl.text = String(0)
        }
    }
    
    
    
}
