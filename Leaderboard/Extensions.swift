//
//  Extensions.swift
//  Leaderboard
//
//  Created by Developer on 7/30/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

extension String {
    func truncate(toLength length: Int, withPostfix postfix: String? = "...") -> String {
        guard characters.count > length else { return self }
        return substring(to: index(startIndex, offsetBy: length)) + (postfix ?? "")
    }
}
