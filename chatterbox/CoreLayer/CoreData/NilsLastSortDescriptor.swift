import Foundation

class NilsLastSortDescriptor: NSSortDescriptor {

    override func copy(with zone: NSZone? = nil) -> Any {
        return NilsLastSortDescriptor(key: self.key, ascending: self.ascending, selector: self.selector)
    }

    override var reversedSortDescriptor: Any {
        return NilsLastSortDescriptor(key: self.key, ascending: !self.ascending, selector: self.selector)
    }

    override func compare(_ object1: Any, to object2: Any) -> ComparisonResult {

        if (object1 as AnyObject).value(forKey: self.key!) == nil && (object2 as AnyObject).value(forKey: self.key!) == nil {
            return .orderedSame
        }

        if (object1 as AnyObject).value(forKey: self.key!) == nil {
            return .orderedDescending
        }
        if (object2 as AnyObject).value(forKey: self.key!) == nil {
            return .orderedAscending
        }

        return super.compare(object1, to: object2)
    }
}
