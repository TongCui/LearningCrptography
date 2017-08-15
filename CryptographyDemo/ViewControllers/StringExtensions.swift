//
//  StringExtensions.swift
//  CryptographyDemo
//
//  Created by tcui on 15/8/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

import Foundation

// MARK: - Extension

extension String {
    func reversedIntString() -> String? {
        guard let number = Int(self) else {
            return nil
        }
        
        return String(-number)
    }
}
