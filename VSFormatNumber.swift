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
    
    var FormatNumberPorcentVS: String {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let format = numberFormatter.stringFromNumber(self)!
        
        var newFormat = format.stringByReplacingOccurrencesOfString(".00", withString: "")
        newFormat = newFormat + "%"
                
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
    
    var RemovePercentVS: String { 
        
        let newStr = self.stringByReplacingOccurrencesOfString("%", withString: "")
        let newStr2 = newStr.stringByReplacingOccurrencesOfString(",", withString: "")
        return newStr2
    }
    
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        
        //Return Parsed Date
        return dateFromString
    }
    

}

extension NSDate {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}
