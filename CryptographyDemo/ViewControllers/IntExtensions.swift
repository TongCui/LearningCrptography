//
//  IntExtensions.swift
//  CryptographyDemo
//
//  Created by tcui on 17/8/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

import Foundation

extension Int {
    internal func divMod(other:Int) -> (quotient:Int, modulus:Int) {
        let quotient = self / other
        let remainder = self % other
        
        if (quotient > 0) || (remainder == 0) {
            return (quotient, remainder)
        } else if quotient == 0  && (self > 0) && (other < 0) {
            let div = quotient - 1
            let result = (div * other) - self
            return (div, -result)
        } else {
            let signSituation = ((self > 0) || (other < 0))
            let div = ((quotient == 0) && signSituation) ? quotient : quotient - 1
            let result = abs((div * other) - self)
            return (div, (other < 0) ? -result : result)
        }
    }
    
    internal func quotRem(other:Int) -> (quotient:Int, remainder:Int) {
        return (self / other, self % other)
    }
}
