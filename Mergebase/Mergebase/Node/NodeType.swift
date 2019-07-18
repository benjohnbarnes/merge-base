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
    case number(Range<Double>?)
    case string(Range<Int>?)
    case data(Range<Int>?)
    case identifier
    
    case tuple([NodeType])
    case set(NodeType, Range<Int>?)
    case array(NodeType, Range<Int>?)
    
    case variant([VariantName: NodeType])
}

public extension Node {
    
    func conforms(to type: NodeType) -> Bool {
        switch (type, self) {
        case (.anything, _):
            return true
            
        case let (.something(type), _):
            return conforms(to: type)
            
        case (.unit, .unit),
             (.bool, .bool),
             (.identifier, .identifier):
            return true
            
        case let (.number(range), .number(number)):
            return range.map { $0 ~= number } ?? true
            
        case let (.string(lengthLimit), .string(string)):
            return lengthLimit.map { $0 ~= string.count } ?? true
            
        case let (.data(lengthLimit), .data(data)):
            return lengthLimit.map { $0 ~= data.count } ?? true
            
        case let (.tuple(elementTypes), .tuple(elements)):
            guard elementTypes.count == elements.count else { return false }
            return zip(elements, elementTypes).first(where: { $0.conforms(to: $1) == false }) == nil
            
        case let (.set(elementType, size), .set(elements)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.first(where: { $0.conforms(to: elementType) == false}) == nil
            
        case let (.array(elementType, size), .array(elements)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.first(where: { $0.conforms(to: elementType) == false}) == nil
            
        case let (.variant(variants), .variant(variantName, value)):
            guard let variantType = variants[variantName] else { return false }
            return value.conforms(to: variantType)
            
        default:
            return false
        }
    }
}

