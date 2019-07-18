//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum Node: Hashable {
    case bool(Bool)
    case identifier(NodeIdentifier)

    case number(Double)
    case string(String)
    case data(Data)
    case type(NodeType)

    case tuple([Node])
    case variant(VariantIdentifier, Node)

    case set(Set<Node>)
    case array([Node])
}

//MARK:-

extension Node {
    
    func conforms(to type: NodeType) -> Bool {
        switch (self, type) {
        case (_, .anything):
            return true
            
        case let (value, .nominal(nominal)):
            return value.conforms(to: nominal.type)
            
        case (.bool, .bool),
             (.identifier, .identifier),
             (.type, .type):
            return true
            
        case let (.number(number), .number(range)):
            return range.map { $0 ~= number } ?? true
            
        case let (.string(string), .string(lengthLimit)):
            return lengthLimit.map { $0 ~= string.count } ?? true
            
        case let (.data(data), .data(lengthLimit)):
            return lengthLimit.map { $0 ~= data.count } ?? true
            
        case let (.tuple(elements), .tuple(elementTypes)):
            guard elementTypes.count == elements.count else { return false }
            return zip(elements, elementTypes).checkAll(pass: { $0.conforms(to: $1) })
            
        case let (.set(elements), .set(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.checkAll(pass: { $0.conforms(to: elementType)})
            
        case let (.array(elements), .array(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.checkAll(pass: { $0.conforms(to: elementType)})
            
        case let (.variant(`case`, value), .variant(variants)):
            guard let type = variants[`case`] else { return false }
            return value.conforms(to: type)
            
        default:
            return false
        }
    }
}

