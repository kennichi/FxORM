package tests.operations {
import tests.operations.remove.OperationsRemoveSuite;
import tests.operations.save.OperationsSaveSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class OperationsSuite {
    public var save : OperationsSaveSuite;
    public var remove : OperationsRemoveSuite;
}
}
