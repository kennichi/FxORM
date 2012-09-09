package tests.operations.save.collections.tests
{
import cache.CacheManager;

import contexts.ReferenceContext;
	
	import data.ReferenceObject;
	
	import core.EntityManager;
	
	import mx.utils.object_proxy;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

import tests.operations.save.collections.tests.CollectionTestBase;

public class PrimitivesCollectionTest extends CollectionTestBase
	{		
		[Test]
		public function testNewIntCollection():void
		{
			var referenceObject : ReferenceObject = createElementaryCollectionObject();
			assertNotNull(referenceObject.intCollection);
			assertEquals(referenceObject.intCollection.length, 10);
			assertEquals(referenceObject.intCollection.getItemAt(4), 4);
		}
		
		[Test]
		public function testNewStringCollection():void
		{
			var referenceObject : ReferenceObject = createElementaryCollectionObject();
			assertNotNull(referenceObject.stringCollection);
			assertEquals(referenceObject.stringCollection.length, 10);
			assertEquals(referenceObject.stringCollection.getItemAt(9), "item 9");
		}
		
		[Test]
		public function testChangedCollection() : void
		{
			var referenceObject : ReferenceObject = createElementaryCollectionObject();
			referenceObject.intCollection.addItem(10);
			referenceObject.save();
            CacheManager.instance.reset();
			referenceObject = entityManager.getObject(referenceObject.objectId) as ReferenceObject;
			assertEquals(referenceObject.intCollection.length, 11);			
			assertEquals(referenceObject.intCollection.getItemAt(3), 3);			
			assertEquals(referenceObject.intCollection.getItemAt(10), 10);
			referenceObject.intCollection.setItemAt(333, 3);
			referenceObject.save();
            CacheManager.instance.reset();
			referenceObject = entityManager.getObject(referenceObject.objectId) as ReferenceObject;
			assertEquals(referenceObject.intCollection.length, 11);			
			assertEquals(referenceObject.intCollection.getItemAt(3), 333);		
		}
		
		[Test]
		public function testChangedChainedCollection() : void
		{
			var rootObject : ReferenceObject = new ReferenceObject();
			var referenceObject : ReferenceObject = createElementaryCollectionObject();
			rootObject.referenceObjectReference = referenceObject;
			rootObject.save();
            CacheManager.instance.reset();
			rootObject = entityManager.getObject(rootObject.objectId) as ReferenceObject;
			assertNotNull(rootObject.referenceObjectReference);
			assertNotNull(rootObject.referenceObjectReference.intCollection);
			assertEquals(rootObject.referenceObjectReference.intCollection.length, 10);
			assertEquals(rootObject.referenceObjectReference.intCollection.getItemAt(4), 4);
			rootObject.referenceObjectReference.intCollection.addItem(35);
			rootObject.save();
            CacheManager.instance.reset();
			rootObject = entityManager.getObject(rootObject.objectId) as ReferenceObject;
			assertEquals(rootObject.referenceObjectReference.intCollection.length, 11);
			assertEquals(rootObject.referenceObjectReference.intCollection.getItemAt(7), 7);
			assertEquals(rootObject.referenceObjectReference.intCollection.getItemAt(10), 35);			
		}
	}
}