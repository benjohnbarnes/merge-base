//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

protocol WritableArrow: Arrow {
    subscript(_ key: Key) -> Value? {get set}
}

