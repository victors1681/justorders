//
//  VSFormatNumber.swift
//  JustOrders
//
//  Created by Victor Santos on 3/30/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import Foundation

extension Double {
    var FormatNumberCurrencyVS: String {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        let format = numberFormatter.stringFromNumber(self)!
    
        let newFormat = format.stringByReplacingOccurrencesOfString(".00", withString: "")
        
        return newFormat
    }
    
    
    var FormatNumberNumberVS: String {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let format = numberFormatter.stringFromNumber(self)!
        
        let newFormat = format.stringByReplacingOccurrencesOfString(".00", withString: "")
        
        
        return newFormat
    }
}

extension String {
    
    var RemoveSymbolVS: String {
        let numberFormatter = NSNumberFormatter()
        let code = numberFormatter.currencySymbol
        
        let newStr = self.stringByReplacingOccurrencesOfString(code, withString: "")
        let newStr2 = newStr.stringByReplacingOccurrencesOfString(",", withString: "")
         return newStr2
    }
}

