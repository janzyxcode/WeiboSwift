//
//  Optional+Extensions.swift
//  ECWallet
//
//  Created by  user on 2018/3/30.
//

import UIKit

extension Optional where Wrapped == Bool {
    var value: Bool {
        guard let wrappedValue = self else {
            return false
        }
        return wrappedValue
    }
}

extension Optional where Wrapped == Double {
    var value: Double {
        guard let wrappedValue = self else {
            return 0.0
        }
        return wrappedValue
    }
}

extension Optional where Wrapped == Float {
    var value: Float {
        guard let wrappedValue = self else {
            return 0.0
        }
        return wrappedValue
    }
}

extension Optional where Wrapped == CGFloat {
    var value: CGFloat {
        guard let wrappedValue = self else {
            return 0.0
        }
        return wrappedValue
    }
}

extension Optional where Wrapped == Int {
    var value: Int {
        guard let wrappedValue = self else {
            return 0
        }
        return wrappedValue
    }
}
