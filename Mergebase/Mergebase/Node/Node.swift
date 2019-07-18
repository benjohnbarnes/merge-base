//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum Node: Hashable {
    case bool(Bool)
    case identifier(Unique)

    case number(Double)
    case string(String)
    case data(Data)

    case tuple([Node])
    case variant(VariantId, Node)

    case set(Set<Node>)
    case array([Node])
}

public struct Unique: Hashable {
    public init() {}
    private let identifier = UUID()
}

public typealias VariantId = String

public extension Node {
    
    func conforms(to type: NodeType) -> Bool {
        switch (self, type) {
        case (_, .anything):
            return true
            
        case let (value, .nominal(nominal)):
            return value.conforms(to: nominal.type)
            
        case (.bool, .bool),
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
            return zip(elements, elementTypes).checkAll(pass: { $0.conforms(to: $1) })
            
        case let (.set(elements), .set(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.checkAll(pass: { $0.conforms(to: elementType)})
            
        case let (.array(elements), .array(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.checkAll(pass: { $0.conforms(to: elementType)})
            
        case let (.variant(variantName, value), .variant(variants)):
            guard let variantType = variants[variantName] else { return false }
            return value.conforms(to: variantType)
            
        default:
            return false
        }
    }
}



