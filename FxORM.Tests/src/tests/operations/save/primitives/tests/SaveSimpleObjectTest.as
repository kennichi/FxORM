package tests.operations.save.primitives.tests
{
import tests.operations.save.primitives.*;
	import data.SimpleObject;
	
	import org.flexunit.asserts.assertEquals;
	
	import tests.BaseTest;

	public class SaveSimpleObjectTest extends SimpleObjectTestBase
	{		
		[Test]
		public function testStringField() : void
		{
			simpleObject.stringValue = "String Test Value";
			var loadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(loadedObject.stringValue, "String Test Value");
			loadedObject.stringValue = "Another string value";
			simpleObject = loadedObject;
			var reloadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(reloadedObject.stringValue, "Another string value");
		}
		[Test]
		public function testFloatField() : void
		{
			simpleObject.floatValue = 0.43334;
			var loadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(loadedObject.floatValue, 0.43334);
			loadedObject.floatValue = 234323.233;
			simpleObject = loadedObject;
			var reloadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			assertEquals(reloadedObject.floatValue, 234323.233);
		}	
	}
}