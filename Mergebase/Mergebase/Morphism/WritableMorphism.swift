//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

protocol WritableMorphism: Morphism {
    subscript(_ key: Key) -> Value? {get set}
}

