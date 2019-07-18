//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum NodeType: Hashable {
    // This is basically a type variable. An extension would be for the variables in a type to be identified, and they
    // would then need to correctly unify for types to match. Think that just `anything` is probably sufficient for
    // now, though.
    case anything
    
    case nominal(NominalNodeType)

    case bool
    case identifier
    case type

    case number(Range<Double>?)
    case string(Range<Int>?)
    case data(Range<Int>?)
    
    case tuple([NodeType])
    case variant([VariantIdentifier: NodeType])

    case set(NodeType, Range<Int>?)
    case array(NodeType, Range<Int>?)
}

