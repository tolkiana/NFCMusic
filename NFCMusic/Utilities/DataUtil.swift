//
//  DataUtil.swift
//  NFCMusic
//
//  Created by Nelida Velazquez on 7/21/19.
//  Copyright © 2019 Detroit Labs LLC. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
    func decode(skipping bytes: Int) -> String {
        guard let message = String(data: self.advanced(by: bytes), encoding: .utf8) else {
            return ""
        }
        return message
    }
    
    func decode() -> String {
        guard let message = String(data: self, encoding: .utf8) else {
            return ""
        }
        return message
    }
}

