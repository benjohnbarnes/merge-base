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
        switch (self, type) {
        case (_, .anything):
            return true
            
        case let (node, .something(type)):
            return node.conforms(to: type)
            
        case (.unit, .unit),
             (.bool, .bool),
             (.identifier, .identifier):
            return true
            
        case let (.number(number), .number(range)):
            return range.map { $0 ~= number } ?? true
            
        case let (.string(string), .string(lengthLimit)):
            return lengthLimit.map { $0 ~= string.count } ?? true
            
        case let (.data(data), .data(lengthLimit)):
            return lengthLimit.map { $0 ~= data.count } ?? true
            
        case let (.tuple(elements), .tuple(elementTypes)):
            guard elementTypes.count == elements.count else { return false }
            return zip(elements, elementTypes).first(where: { $0.conforms(to: $1) == false }) == nil
            
        case let (.set(elements), .set(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.first(where: { $0.conforms(to: elementType) == false}) == nil
            
        case let (.array(elements), .array(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.first(where: { $0.conforms(to: elementType) == false}) == nil
            
        case let (.variant(variantName, value), .variant(variants)):
            guard let variantType = variants[variantName] else { return false }
            return value.conforms(to: variantType)
            
        default:
            return false
        }
    }
}

