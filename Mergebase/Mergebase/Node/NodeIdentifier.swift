//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


public enum NodeIdentifier: Hashable {
    
    public init() {
        self = .uuid(UUID())
    }
    
    case uuid(UUID)
    case string(String)
    case url(URL)
}

