//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

extension NodeType {
    
    func conforms(to other: NodeType) -> Bool {
        switch (self, other) {
        case (_, .anything),
             (.bool, .bool),
             (.identifier, .identifier),
             (.type, .type):
            return true
            
        case let (.nominal(this), .nominal(that)):
            return this == that
            
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

extension NodeType: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeValue<T: Decodable>() throws -> T {
            return try container.decode(T.self, forKey: .value)
        }
        
        func decodeRange<R: Decodable>() throws -> R {
            return try container.decode(R.self, forKey: .range)
        }
        
        let kind = try container.decode(Case.self, forKey: .case)
        
        switch kind {
            
        case .anything: self = .anything
        case .nominal: self = .nominal(try decodeValue())
        case .bool: self = .bool
        case .identifier: self = .identifier
        case .type: self = .type
        case .number: self = .number(try decodeValue())
        case .string: self = .string(try decodeValue())
        case .data: self = .data(try decodeValue())
        case .tuple: self = .tuple(try decodeValue())
        case .variant: self = .variant(try decodeValue())
        case .set: self = .set(try decodeValue(), try decodeRange())
        case .array: self = .array(try decodeValue(), try decodeRange())
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    private enum Case: String, Codable {
        case anything = "any"
        case nominal = "nom"
        case bool = "boo"
        case identifier = "id"
        case type = "typ"
        case number = "num"
        case string = "str"
        case data = "dat"
        case tuple = "tup"
        case variant = "var"
        case set = "set"
        case array = "arr"
    }
    
    private enum CodingKeys: String, CodingKey {
        case `case` = "c"
        case value = "v"
        case range = "r"
    }
}
