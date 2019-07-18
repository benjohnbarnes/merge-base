//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public protocol NominalTypeGateway {
    func type(of nominalIdentifier: NominalIdentifier) -> NodeType?
}

public struct NodeTypeValidator {

    public init(typeGateway: NominalTypeGateway? = nil) {
        self.typeGateway = typeGateway
    }
    
    public func validate(node: Node, conformsTo type: NodeType) -> Bool {
        switch (node, type) {
        case (_, .anything):
            return true
            
        case let (value, .nominal(nominal)):
            guard let type = typeGateway?.type(of: nominal) else { return false }
            return validate(node: value, conformsTo: type)
            
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
            return zip(elements, elementTypes).checkAll(pass: { self.validate(node: $0, conformsTo: $1) })
            
        case let (.set(elements), .set(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.checkAll(pass: { self.validate(node: $0, conformsTo: elementType) })
            
        case let (.array(elements), .array(elementType, size)):
            if let size = size, (size ~= elements.count) == false { return false }
            return elements.checkAll(pass: { self.validate(node: $0, conformsTo: elementType) })
            
        case let (.variant(`case`, value), .variant(variants)):
            guard let type = variants[`case`] else { return false }
            return self.validate(node: value, conformsTo: type)
            
        default:
            return false
        }
    }
    
    private let typeGateway: NominalTypeGateway?
}

