//
//  UINib+.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 14.12.2022.
//

import UIKit


extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}
