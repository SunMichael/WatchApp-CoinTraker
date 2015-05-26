/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import WatchKit
import Foundation
import CoinKit

class CoinsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var coinTable: WKInterfaceTable!
    
  var coins = [Coin]()
  let coinHelper = CoinHelper()
    
    func reloadTable(){
        
        if coinTable.numberOfRows != coins.count {
            coinTable.setNumberOfRows(coins.count, withRowType: "CoinRow")
        }
        
//        coinTable.setNumberOfRows(10, withRowType: "CoinRow")
        for (index ,coin) in enumerate(coins) {
            if let row = coinTable.rowControllerAtIndex(index) as? CoinRow {
                row.titleLabel.setText(coin.name)
                row.detailLabel.setText("\(coin.price)")
            }
        }
    }
    
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    coins = coinHelper.cachedPrices()
    reloadTable()
    
    // 强行ios app 登陆 []内是传递给iPhone的参数 遵循plist数据格式
    WKInterfaceController.openParentApplication(["request": "refreshData"], reply: { (replyInfo, error) -> Void in
        // iphone 与 watch 之间二进制数据传输
        NSLog("Reply: \(replyInfo)")
        
        if let coinData = replyInfo["coinData"] as? NSData {
            if let coins = NSKeyedUnarchiver.unarchiveObjectWithData(coinData) as? [Coin] {  //将数据解档
                self.coinHelper.cachePriceData(coins)
                self.coins = coins
                self.reloadTable()
            }
        }
        
    })
    
  }
    //通过控制器之间内建方式发送数据包
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if segueIdentifier == "CoinDetails" {
            let coin = coins[rowIndex]
            return coin
        }
        return nil
    }
    //handoff 传递数据 用户点击glance 跳转到对应的货币详情界面   
    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
       let coinString = userInfo?["coin"] as? String
        if let handedCoin = coinString {
            for coin in coins {
                if coin.name == handedCoin {
                    pushControllerWithName("CoinDetailInterfaceController", context: coin)
                }
            }
        }

        
    }
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

}
