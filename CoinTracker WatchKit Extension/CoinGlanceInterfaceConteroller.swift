//
//  CoinGlanceInterfaceConteroller.swift
//  CoinTracker
//
//  Created by mac on 15/5/26.
//  Copyright (c) 2015年 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit
import CoinKit

//storeborad里添加的Glance interface 要有对应的conteroller
//glance测试 要在manage scheme 里duplicat新的scheme info 中watch mian 改成glance
class CoinGlanceInterfaceController: WKInterfaceController {
    @IBOutlet weak var coinImage: WKInterfaceImage!
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    
    let helper = CoinHelper()
    let defaults = NSUserDefaults.standardUserDefaults()
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let favoriteCoin = defaults.stringForKey("favoriteCoin")
        let coins = helper.cachedPrices()
        for coin in coins {
            if coin.name == favoriteCoin {
                coinImage.setImageNamed(coin.name)
                nameLabel.setText(coin.name)
                priceLabel.setText("\(coin.price)")
                
//              这里你通知WatchKit了这里有一个user activity。在这个例子中，是指用户在速览某个货币。
                updateUserActivity("com.treebear.glance", userInfo: ["coin": coin.name], webpageURL: nil)
                
                break
            }
        }
        
    }
}