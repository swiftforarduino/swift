@usableFromInline
internal class ConstantSizeBuffer<let count: Int, T: BinaryInteger> {
    var memory: InlineArray<count,T>
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { self.count - 1 }
    
    public var count: Int {
        get { memory.count }
    }

    public init(repeating value: T) {
        self.memory = InlineArray<count,T>(repeating: value)
    }
}

internal let testConstantSizeBuffer = ConstantSizeBuffer<1,UInt32>.init(repeating: 0)
