package tests.operations.save {
import tests.operations.save.collections.OperationsSaveCollectionsSuite;
import tests.operations.save.references.OperationSaveReferencesSuite;
import tests.operations.save.primitives.OperationsSavePrimitiveSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class OperationsSaveSuite {
    public var collections : OperationsSaveCollectionsSuite;
    public var references : OperationSaveReferencesSuite;
    public var primitives : OperationsSavePrimitiveSuite;
}
}
