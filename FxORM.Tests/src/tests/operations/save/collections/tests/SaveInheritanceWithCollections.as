package tests.operations.save.collections.tests
{
	import IPersistentObject;
	
	import data.CollectionObject;
	import data.SimpleObject;
	
	import core.EntityManager;
	
	import flashx.textLayout.debug.assert;
	
	import mx.utils.object_proxy;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	
	import tests.BaseTest;
import tests.operations.save.collections.tests.CollectionTestBase;

import utils.PersistenceUtils;

	public class SaveInheritanceWithCollections extends CollectionTestBase
	{		
		[Test]
		public function testSaveNewItemWithCollectionInBaseClass() : void
		{
			// new
			var loaded : CollectionObject = createCollectionInBaseClass();
			var newItem : SimpleObject = new SimpleObject();
			newItem.intValue = 787;
			loaded.simpleObjectsCollection.addItem(newItem);
			entityManager.save(loaded);
			loaded = entityManager.getObject(loaded.objectId) as CollectionObject;
			assertEquals(loaded.simpleObjectsCollection.length, 11);
			assertTrue(PersistenceUtils.existsInDB(newItem));
			assertEquals(SimpleObject(loaded.simpleObjectsCollection.getItemAt(10)).intValue, 787);
			// persistant
			var simple : SimpleObject = new SimpleObject();
			simple.intValue = 6000;
			entityManager.save(simple);
			loaded.simpleObjectsCollection.addItem(simple);
			entityManager.save(loaded);
			loaded = entityManager.getObject(loaded.objectId) as CollectionObject;
			assertEquals(loaded.simpleObjectsCollection.length, 12);
			assertEquals(SimpleObject(loaded.simpleObjectsCollection.getItemAt(11)).intValue, 6000);
		}
		[Test]
		public function testSaveChangedCollectionInBaseClass() : void
		{
			var loaded : CollectionObject = createCollectionInBaseClass();
			var item : SimpleObject = loaded.simpleObjectsCollection.getItemAt(9) as SimpleObject;
			item.intValue = 31415;
			entityManager.save(loaded);
			loaded = entityManager.getObject(loaded.objectId) as CollectionObject;
			assertEquals(SimpleObject(loaded.simpleObjectsCollection.getItemAt(9)).intValue, 31415);
		}	
		[Test]
		public function testSaveNewItemWithCollectionInChildClass() : void
		{
			// done in existing collection tests
		}
		[Test]
		public function testSaveChangedCollectionInChildClass() : void
		{
			// done in existing collection tests
		}	
		
	}	
}