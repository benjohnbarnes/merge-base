//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

extension Sequence {
    
    func checkAll(pass predicate: (Element) -> Bool) -> Bool {
        return first(where: { predicate($0) == false }) == nil
    }
}
