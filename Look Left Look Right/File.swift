//
//  File.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/9/25.
//

import Foundation

extension Array {
    func safelyGet(index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }
        
        return self[index]
    }
}
