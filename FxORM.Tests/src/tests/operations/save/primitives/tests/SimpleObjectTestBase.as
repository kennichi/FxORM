package tests.operations.save.primitives.tests
{
	import data.SimpleObject;
	
	import core.EntityManager;
	
	import tests.TestUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertNotNull;
	
	import tests.BaseTest;
	
	public class SimpleObjectTestBase extends BaseTest
	{
		protected var simpleObject : SimpleObject;
		[Before(order=2)]
		public function setUp():void
		{
			simpleObject = new SimpleObject();
		}	
		
		protected function saveAndLoadSimpleObjectFromDB() : SimpleObject
		{
			var objectId:uint = entityManager.save(simpleObject);
            var simpleObjectsFromDB : Array = entityManager.findAll(SimpleObject);
			TestUtils.assertCollection(new ArrayCollection(simpleObjectsFromDB), 1, SimpleObject);
            var loadedObject : SimpleObject = SimpleObject(entityManager.refresh(objectId));
			assertNotNull(loadedObject);
			return loadedObject;
		}
	}
}