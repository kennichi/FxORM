package tests.operations.save.primitives.tests
{
import tests.operations.save.primitives.*;
	import data.SimpleObject;
	
	import core.EntityManager;
	
	import utils.DateUtils;
	import tests.TestUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	
	import tests.BaseTest;

	public class SaveDateTest extends SimpleObjectTestBase
	{	
		[Test]
		public function testValidDate() : void
		{
			var date : Date = new Date();
			var date2 : Date = new Date(2007, 11, 23, 0,0,0,0);
			testDateValue(date, date2);
		}	
		
		[Test]
		public function testNullDate() : void
		{
			var someDate : Date = new Date(2011, 0, 12, 0, 0, 0, 0);
			testDateValue(null, someDate);
			testDateValue(someDate, null);
			testDateValue(null, null);
		}
		
		[Test]
		public function testBoundaryValues() : void
		{
			var date : Date = new Date(0);
			testDateValue(date, new Date());
			testDateValue(new Date(), date);
		}
		
		private function testDateValue(date1 : Date, date2 : Date) : void
		{
			simpleObject.dateValue = date1;
			var loadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			if (date1 && date1.getTime() != 0)
			{
				date1.milliseconds = 0;			
				assertEquals(loadedObject.dateValue.getTime(), date1.getTime());
			}
			else
			{
				assertNull(loadedObject.dateValue);
			}
			loadedObject.dateValue = date2;
			simpleObject = loadedObject;
			var reloadedObject : SimpleObject = saveAndLoadSimpleObjectFromDB();
			if (date2 && date2.getTime() != 0)
			{
				date2.milliseconds = 0;
				assertEquals(reloadedObject.dateValue.getTime(), date2 ? date2.getTime() : 0);
			}
			else
			{
				assertNull(reloadedObject.dateValue);
			}
		}
	}
}