package tests.operations.save.collections.tests
{
	import data.CollectionObject;
	
	import core.EntityManager;
	
	import mx.utils.object_proxy;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	
	import tests.BaseTest;
import tests.operations.save.collections.tests.CollectionTestBase;

public class SaveNullCollectionTest extends CollectionTestBase
	{		
		[Test]
		public function testSavePersistanCollectionSetToNull() : void
		{
			var loaded : CollectionObject = createCollectionInBaseClass();
			assertNotNull(loaded.simpleObjectsCollection);
			loaded.simpleObjectsCollection = null;
			entityManager.save(loaded);
			loaded = entityManager.getObject(loaded.objectId) as CollectionObject;
			assertNull(loaded.simpleObjectsCollection);
		}
		
		[Test]
		public function testSaveNewCollectionSetToNull() : void
		{	
			var loaded : CollectionObject = createSimpleCollectionObject();
			assertNull(loaded.collectionObjectsCollection);
		}
	}
}