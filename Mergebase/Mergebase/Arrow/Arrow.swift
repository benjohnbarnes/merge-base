//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

protocol Arrow {
    associatedtype Key: Hashable
    associatedtype Value

    func records() -> [Key:Value]
}
