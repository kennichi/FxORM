package tests.operations.save.primitives.tests
{
import tests.operations.save.primitives.*;
	import data.SimpleObject;
	
	import org.flexunit.asserts.assertEquals;

	public class SaveBooleanTest extends SimpleObjectTestBase
	{		
		[Test]
		public function testTrue() : void
		{
			simpleObject.boolValue = true;
			var loadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(loadedObject.boolValue, true);		
		}	
		[Test]
		public function testFalse() : void
		{
			simpleObject.boolValue = false;
			var loadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(loadedObject.boolValue, false);		
		}	
	}
}