package tests.operations.save.references {
import tests.operations.save.references.tests.SaveInheritanceWithReferencesTest;
import tests.operations.save.references.tests.SaveNullReferenceTest;
import tests.operations.save.references.tests.SaveReferenceChainTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class OperationSaveReferencesSuite {
        public var inheritance : SaveInheritanceWithReferencesTest;
        public var nullRef : SaveNullReferenceTest;
        public var chain : SaveReferenceChainTest;
    }
}
