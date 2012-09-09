package tests.operations.save.primitives {
import tests.operations.save.primitives.tests.SaveBooleanTest;
import tests.operations.save.primitives.tests.SaveDateTest;
import tests.operations.save.primitives.tests.SaveDuplicatedIdTests;
import tests.operations.save.primitives.tests.SaveIntValuesTest;
import tests.operations.save.primitives.tests.SaveSimpleObjectInheritanceTest;
import tests.operations.save.primitives.tests.SaveSimpleObjectTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class OperationsSavePrimitiveSuite {
    public var boolean : SaveBooleanTest;
    public var date : SaveDateTest;
    public var duplicatedId : SaveDuplicatedIdTests;
    public var intVal : SaveIntValuesTest;
    public var simpleInheritance : SaveSimpleObjectInheritanceTest;
    public var simple : SaveSimpleObjectTest;
}
}
