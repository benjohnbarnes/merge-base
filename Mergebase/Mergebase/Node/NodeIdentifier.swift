//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


public enum NodeIdentifier: Hashable {
    case uuid(UUID)
    case string(String)
    case url(URL)
}

