package tests.operations.save.collections.tests
{
	import data.CollectionObject;
	
	import core.EntityManager;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;
	
	import tests.BaseTest;

	public class SaveEmptyCollectionTest extends BaseTest
	{		
		[Test]
		public function testSaveNewObjectWithEmptyCollection() : void
		{
			var obj : CollectionObject = new CollectionObject();
			obj.referenceObjectsCollection = new ArrayCollection();
			entityManager.save(obj);
			obj = entityManager.getObject(obj.objectId) as CollectionObject;
			assertEquals(obj.referenceObjectsCollection.length, 0);
			
		}
		
	}
}