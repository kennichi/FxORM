package tests.queries {
import tests.queries.tests.CollectionQueryTests;
import tests.queries.tests.ReferenceQueryTests;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class QueriesSuite {
    public var collections : CollectionQueryTests;
    public var references : ReferenceQueryTests;
}
}
