//
//  NFCMessageDecoder.swift
//  NFCMusic
//
//  Created by Nelida Velazquez on 7/19/19.
//  Copyright © 2019 Detroit Labs LLC. All rights reserved.
//

import CoreNFC

enum PayloadType: String {
    case text = "T"
    case uri = "U"
    case unkown
    
    init(rawValue: String) {
        switch rawValue {
        case "U": self = .uri
        case "T": self = .text
        default: self = .unkown
        }
    }
}

class NFCMessageDecoder {
    
    func decode(_ message: NFCNDEFMessage) -> [String] {
        return message.records.compactMap { payload in
            return self.decode(payload)
        }
    }
    
    private func decode(_ payload: NFCNDEFPayload) -> String? {
        let type = PayloadType(rawValue: payload.type.decode())
        switch type {
        case .uri:
            return payload.wellKnownTypeURIPayload()?.absoluteString
        case .text:
            return payload.wellKnownTypeTextPayload().0
        default:
            return nil
        }
    }
}
