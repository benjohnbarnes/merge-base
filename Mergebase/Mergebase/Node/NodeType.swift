//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum NodeType: Hashable {
    // This is basically a type variable. An extension would be for the variables in a type to be identified, and they
    // would then need to correctly unify for types to match. Think that just `anything` is probably sufficient for
    // now, though.
    case anything
    
    // The "something" case needs to be enforced on the container of the type. Given a Node, you can
    // only see if it can be a match. To guarantee a match its necessary to check NodeType.
    case something(NodeType)
    
    case unit
    
    case bool
    case identifier
    case number(Range<Double>?)
    case string(Range<Int>?)
    case data(Range<Int>?)
    
    case tuple([NodeType])
    case set(NodeType, Range<Int>?)
    case array(NodeType, Range<Int>?)
    
    case variant([VariantName: NodeType])
}

extension NodeType {
    
    func conforms(to other: NodeType) -> Bool {
        switch (self, other) {
        case (_, .anything),
             (.unit, .unit),
             (.bool, .bool),
             (.identifier, .identifier):
            return true
            
        case let (.number(innerRange), .number(outerRange)):
            return range(innerRange, isSubRangeOf: outerRange)

        case let (.string(innerRange), .string(outerRange)),
             let (.data(innerRange), .data(outerRange)):
            return range(innerRange, isSubRangeOf: outerRange)

        case let (.tuple(innerTypes), .tuple(outerTypes)):
            guard innerTypes.count == outerTypes.count else { return false }
            return zip(innerTypes, outerTypes).checkAll(pass: { $0.0.conforms(to: $0.1) })
            
        case let (.set(innerType, innerRange), .set(outerType, outerRange)),
             let (.array(innerType, innerRange), .array(outerType, outerRange)):
            guard range(innerRange, isSubRangeOf: outerRange) else { return false }
            return innerType.conforms(to: outerType)
            
        case let (.variant(innerCases), .variant(outerCases)):
            return innerCases.checkAll(pass: {
                innerCaseAndType in
                guard let outerType = outerCases[innerCaseAndType.key] else { return false }
                return innerCaseAndType.value.conforms(to: outerType)
                })
            
        default:
            return false
        }
    }
}

private func range<T>(_ innerRange: Range<T>?, isSubRangeOf outerRange: Range<T>?) -> Bool {
    if let outerRange = outerRange {
        guard let innerRange = innerRange else { return false}
        return outerRange ~= innerRange
    }
    else {
        return true
    }
    
}

