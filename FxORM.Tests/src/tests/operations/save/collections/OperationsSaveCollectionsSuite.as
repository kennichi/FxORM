package tests.operations.save.collections {
import tests.operations.save.collections.tests.SaveEmptyCollectionTest;
import tests.operations.save.collections.tests.SaveExistingCollectionTest;
import tests.operations.save.collections.tests.SaveInheritanceWithCollections;
import tests.operations.save.collections.tests.SaveLazyNotLoadedCollectionTest;
import tests.operations.save.collections.tests.SaveNewCollectionTest;
import tests.operations.save.collections.tests.SaveNullCollectionTest;
import tests.operations.save.collections.tests.PrimitivesCollectionTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class OperationsSaveCollectionsSuite {
        public var empty : SaveEmptyCollectionTest;
        public var existing : SaveExistingCollectionTest;
        public var inheritance : SaveInheritanceWithCollections;
        public var lazy : SaveLazyNotLoadedCollectionTest;
        public var newColl : SaveNewCollectionTest;
        public var nullColl : SaveNullCollectionTest;
        public var primitive : PrimitivesCollectionTest;
    }
}
