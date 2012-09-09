package tests.operations.save.primitives.tests
{
import tests.operations.save.primitives.*;
	import data.SimpleObject;
	
	import org.flexunit.asserts.assertEquals;
	
	import tests.BaseTest;

	public class SaveIntValuesTest extends SimpleObjectTestBase
	{		
		[Test]
		public function testValidValue() : void
		{
			testIntValue(2232, 117);
		}
		[Test]
		public function testZeroValue() : void
		{
			testIntValue(0, 111);
			testIntValue(1, 0);
		}
		
		[Test]
		public function testBoundaryValues() : void
		{
			testIntValue(int.MAX_VALUE, int.MIN_VALUE);
		}
		
		private function testIntValue(val1 : int, val2 : int) : void
		{
			simpleObject.intValue = val1;
			var loadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(loadedObject.intValue, val1);
			simpleObject = loadedObject;
			simpleObject.intValue = val2;
			var reloadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(reloadedObject.intValue, val2);			
		}
	}
}