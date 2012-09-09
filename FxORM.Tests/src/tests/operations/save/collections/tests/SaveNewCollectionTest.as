package tests.operations.save.collections.tests
{
	import data.CollectionObject;
	import data.ReferenceObject;
	
	import core.EntityManager;
	
	import mx.collections.ArrayCollection;
	import mx.utils.object_proxy;
	
	import org.flexunit.asserts.assertEquals;
	
	import tests.BaseTest;
import tests.operations.save.collections.tests.CollectionTestBase;

public class SaveNewCollectionTest extends CollectionTestBase
	{		
		[Test]
		public function testSaveCollectionWithPersistantUnchangedItems() : void
		{
			var loaded : CollectionObject = createSimpleCollectionObject();
			var newColl : CollectionObject = new CollectionObject();
			newColl.referenceObjectsCollection = new ArrayCollection();
			for each (var item : ReferenceObject in loaded.referenceObjectsCollection)
			{
				newColl.referenceObjectsCollection.addItem(item);
			}
			entityManager.save(newColl);
			newColl = entityManager.getObject(newColl.objectId) as CollectionObject;
			for (var i : int = 0; i < 10; i++)
			{
				var persItem : ReferenceObject = loaded.referenceObjectsCollection.getItemAt(i) as ReferenceObject;
				var newItem : ReferenceObject = newColl.referenceObjectsCollection.getItemAt(i) as ReferenceObject;
				assertEquals(persItem.objectId, newItem.objectId);
				assertEquals(persItem.intValue, newItem.intValue);
			}
		}
		
		[Test]
		public function testSaveCollectionWithPersistantChangedItems() : void
		{
			var loaded : CollectionObject = createSimpleCollectionObject();
			var newColl : CollectionObject = new CollectionObject();
			newColl.referenceObjectsCollection = new ArrayCollection();
			for each (var item : ReferenceObject in loaded.referenceObjectsCollection)
			{
				item.intValue *= 2;
				newColl.referenceObjectsCollection.addItem(item);
			}
			entityManager.save(newColl);
			newColl = entityManager.getObject(newColl.objectId) as CollectionObject;
			for (var i : int = 0; i < 10; i++)
			{
				var newItem : ReferenceObject = newColl.referenceObjectsCollection.getItemAt(i) as ReferenceObject;
				assertEquals(newItem.intValue, 2*i);
			}
		}
		
		[Test]
		public function testSaveCollectionWithSomeNewSomePersistantUnchangedAndSomePersistantChangedItems() : void
		{
			// TODO... 
		}
		
	}
}