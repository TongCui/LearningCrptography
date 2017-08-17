//
//  DictionaryExtensions.swift
//  CryptographyDemo
//
//  Created by tcui on 17/8/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

import Foundation

func flip <T, U>(_ dictionary: Dictionary<U, T>) -> Dictionary<T, U> {
    
    let arrayOfValues: [T] = Array(dictionary.values)
    let arrayOfKeys: [U] = Array(dictionary.keys)
    
    var newDictionary: [T: U] = [:]
    
    for i in 0...arrayOfValues.count-1 {
        newDictionary[arrayOfValues[i]] = arrayOfKeys[i]
        
    }
    
    return newDictionary
}

extension Dictionary where Key == Int, Value == Int {
    func printEnigamaRotor() {
        print("=====")
        var res = [String]()
        (0..<26).forEach { idx in
            let value = self[idx]!
            res.append("<\(idx) -> \(value)>")
        }
        print(res.joined(separator: ", "))
        print("=====")
    }
}
