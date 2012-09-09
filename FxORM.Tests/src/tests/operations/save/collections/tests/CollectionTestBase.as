package tests.operations.save.collections.tests
{
import cache.CacheManager;

import data.AnotherReferenceObject;
	import data.CollectionObject;
	import data.ReferenceObject;
	import data.SimpleObject;

	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	
	import tests.BaseTest;

	[Test]
	public class CollectionTestBase extends BaseTest
	{
		
		protected function createCollectionInBaseClass() : CollectionObject
		{
			var obj : CollectionObject = new CollectionObject();
			obj.simpleObjectsCollection = new ArrayCollection();
			for (var i : int = 0; i < 10; i++)
			{
				var item :SimpleObject = new SimpleObject();
				item.intValue = i;
				obj.simpleObjectsCollection.addItem(item);
			}
			entityManager.save(obj);
			var loaded : CollectionObject = entityManager.getObject(obj.objectId) as CollectionObject;
			assertEquals(loaded.simpleObjectsCollection.length, 10);
			assertEquals(SimpleObject(loaded.simpleObjectsCollection.getItemAt(7)).intValue, 7);
			return loaded;
		}
		
		protected function createCollection(base : int = 0) : ArrayCollection
		{
			var result : ArrayCollection = new ArrayCollection();
			for (var i : int = 0; i < 10; i++)
			{
				var ref1 : ReferenceObject = new ReferenceObject();
				var index : int = base + i;
				ref1.stringValue = "Item No." + index + ": Reference 1";
				ref1.intValue = index;
				var ref2 : AnotherReferenceObject = new AnotherReferenceObject();
				ref2.stringValue = "Item No." + index + ": Reference 2 (Another)";
				ref2.intValue = index*index;
				var ref3 : SimpleObject = new SimpleObject();
				ref3.stringValue  = "Item No." + index + ": Reference 3 (Simple)";
				ref3.intValue = index*index*index;
				ref1.anotherReferenceObjectReference = ref2;
				ref2.reference = ref3;
				result.addItem(ref1);
			}
			return result;
		}
		
		protected function createElementaryCollectionObject() : ReferenceObject
		{
			var referenceObject : ReferenceObject = new ReferenceObject();
			for (var i : int = 0; i < 10; i++)
			{				
				referenceObject.stringCollection.addItem("item " + i);
				referenceObject.intCollection.addItem(i);
			}
			referenceObject.save();
            CacheManager.instance.reset();
			referenceObject = entityManager.getObject(referenceObject.objectId) as ReferenceObject;
			return referenceObject;			
		}
		
		protected function createSimpleCollectionObject() : CollectionObject
		{
			var obj : CollectionObject = new CollectionObject();
			obj.referenceObjectsCollection = createCollection();
			entityManager.save(obj);
			var loaded : CollectionObject = entityManager.getObject(obj.objectId) as CollectionObject;
			
			assertNotNull(loaded);
			assertNotNull(loaded.referenceObjectsCollection);
			assertEquals(10, loaded.referenceObjectsCollection.length);
			var item5_1 : ReferenceObject = ReferenceObject(loaded.referenceObjectsCollection.getItemAt(5));
			assertEquals(item5_1.intValue, 5);
			assertEquals(item5_1.stringValue, "Item No.5: Reference 1");
			var item5_2 : AnotherReferenceObject = item5_1.anotherReferenceObjectReference as AnotherReferenceObject;
			assertEquals(item5_2.intValue, 25);
			assertEquals(item5_2.stringValue, "Item No.5: Reference 2 (Another)");
			var item5_3 : SimpleObject = item5_2.reference;
			assertEquals(item5_3.intValue, 125);
			assertEquals(item5_3.stringValue, "Item No.5: Reference 3 (Simple)");
			
			return loaded;
		}
	}
}