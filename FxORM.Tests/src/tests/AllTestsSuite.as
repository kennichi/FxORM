package tests {
import tests.operations.OperationsSuite;
import tests.queries.QueriesSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AllTestsSuite {
    public var operations : OperationsSuite;
    public var queries : QueriesSuite;
}
}
