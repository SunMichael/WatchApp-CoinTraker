//
//  CoinDetailInterfaceController.swift
//  CoinTracker
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit
import CoinKit
class CoinDetailsInterfaceController: WKInterfaceController {
    var coin: Coin!
    @IBOutlet weak var coinImage : WKInterfaceImage!
    @IBOutlet weak var nameLabel : WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var favoriteSwitch: WKInterfaceSwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let favoriteCoinKey = "favoriteCoin"
    
    //重写此方法为以后的glance 传递数据
    override func awakeWithContext(context: AnyObject?) {
        if let coin = context as? Coin {
            self.coin = coin
            setTitle(coin.name)
            
            coinImage.setImageNamed(coin.name)
            nameLabel.setText(coin.name)
            
            
            let titles = ["Current Price","Yesterday's Price","Volume"]
            let values = ["\(coin.price)USD","\(coin.price24h)USD",String(format: "%.4f",coin.volume)]
            table.setNumberOfRows(titles.count, withRowType: "CoinRow")
            let number = titles.count
            for i in 0..<number {
                if let row = table.rowControllerAtIndex(i) as? CoinRow {
                    row.titleLabel.setText(titles[i])
                    row.detailLabel.setText(values[i])
                }
            }
            if let favoriteCoin = defaults.stringForKey(favoriteCoinKey) {
                favoriteSwitch.setOn(favoriteCoin == coin.name)
            }
            NSLog(" \(self.coin)")
        }
        
    }
    
    @IBAction func favoriteSwitchValueChanged(value: Bool) {
        
        if let coin = coin {
           defaults.removeObjectForKey(favoriteCoinKey)
            if value {
                defaults.setObject(coin.name, forKey: favoriteCoinKey)
            }
            defaults.synchronize()
        }
        
    }
}