package tests.operations.save.collections.tests
{
	import data.AnotherReferenceObject;
	import data.CollectionObject;
	import data.ReferenceObject;
	import data.SimpleObject;
	
	import core.EntityManager;
	
	import mx.collections.ArrayCollection;
	import mx.utils.object_proxy;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	
	import tests.BaseTest;
import tests.operations.save.collections.tests.CollectionTestBase;

public class SaveExistingCollectionTest extends CollectionTestBase
	{		
		[Test]
		public function testSaveCollectionSetFromNullToItems() : void
		{
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			var simpleColl : ArrayCollection = new ArrayCollection();
			for (var i : int = 0; i < 5; i++)
			{
				var item : SimpleObject = new SimpleObject();
				item.stringValue = "Simple " + i;
				item.intValue = i;
				item.floatValue = 1.5*i;
				simpleColl.addItem(item);
			}
			objFromDB.simpleObjectsCollection = simpleColl;
			entityManager.save(objFromDB);
			var reloaded : CollectionObject = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(reloaded.simpleObjectsCollection.length, 5);
			var item3 : SimpleObject = reloaded.simpleObjectsCollection.getItemAt(3) as SimpleObject;
			assertEquals(item3.intValue, 3);
			assertEquals(item3.floatValue, 4.5);
			assertEquals(item3.stringValue, "Simple 3");
			
		}
		
		[Test]
		public function testItemAddedToCollection() : void
		{
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			var ref : ReferenceObject = new ReferenceObject();
			ref.stringValue = "A new reference Object";
			objFromDB.referenceObjectsCollection.addItem(ref);
			ref = new ReferenceObject();
			ref.stringValue = "And another new reference Object";
			objFromDB.referenceObjectsCollection.addItem(ref);
			entityManager.save(objFromDB);
			objFromDB = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(objFromDB.referenceObjectsCollection.length, 12);
			var item10 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(10) as ReferenceObject;
			var item11 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(11) as ReferenceObject;
			assertEquals(item10.stringValue, "A new reference Object");
			assertEquals(item11.stringValue, "And another new reference Object");
			
		}
		
		[Test]
		public function testItemRemovedFromCollection() : void
		{
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			objFromDB.referenceObjectsCollection.removeItemAt(5);
			objFromDB.referenceObjectsCollection.removeItemAt(1);
			entityManager.save(objFromDB);
			objFromDB = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(objFromDB.referenceObjectsCollection.length, 8);
			var item1_2 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(1) as ReferenceObject;
			var item5_7 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(5) as ReferenceObject;
			assertEquals(item1_2.intValue, 2);
			assertEquals(item5_7.intValue, 7);
		}
		
		[Test]
		public function testItemsSubstitutedInCollection() : void
		{
			// NEW
			var ref : ReferenceObject = new ReferenceObject();
			ref.stringValue = "new ref object"; 
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			objFromDB.referenceObjectsCollection.setItemAt(ref, 3);
			entityManager.save(objFromDB);
			objFromDB = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(objFromDB.referenceObjectsCollection.length, 10);
			assertEquals(ReferenceObject(objFromDB.referenceObjectsCollection.getItemAt(3)).stringValue, "new ref object");
			// PERSISTANT
			ref.stringValue = "persistant version";
			entityManager.save(ref);
			ref = entityManager.getObject(ref.objectId) as ReferenceObject;
			objFromDB.referenceObjectsCollection.setItemAt(ref, 9);
			entityManager.save(objFromDB);
			objFromDB = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(objFromDB.referenceObjectsCollection.length, 10);
			assertEquals(ReferenceObject(objFromDB.referenceObjectsCollection.getItemAt(9)).stringValue, "persistant version");
			
			
		}
		
		[Test]
		public function testItemAddedAndDeletedFromCollection() : void
		{
			var ref : ReferenceObject = new ReferenceObject();
			ref.intValue = 23432; 
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			objFromDB.referenceObjectsCollection.addItem(ref);
			objFromDB.referenceObjectsCollection.removeItemAt(10);
			entityManager.save(objFromDB);
			objFromDB = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(objFromDB.referenceObjectsCollection.length, 10);
			var i : int = 0;
			for each (var item : ReferenceObject in objFromDB.referenceObjectsCollection)
			{
				assertEquals(item.intValue, i++);
			}
		}
		
		[Test]
		public function testItemRemovedAndAddedToCollection() : void
		{
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			var ref : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(5) as ReferenceObject;
			objFromDB.referenceObjectsCollection.removeItemAt(5);
			objFromDB.referenceObjectsCollection.addItemAt(ref, 5);
			entityManager.save(objFromDB);
			objFromDB = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			assertEquals(objFromDB.referenceObjectsCollection.length, 10);
			ref = objFromDB.referenceObjectsCollection.getItemAt(5) as ReferenceObject;
			var i : int = 0;
			for each (var item : ReferenceObject in objFromDB.referenceObjectsCollection)
			{
				assertEquals(item.intValue, i++);
			}
			
		}
		
		[Test]
		public function testItemsChanged() : void
		{
			var objFromDB : CollectionObject = createSimpleCollectionObject();
			// NEW OBJECTS:
			// case 1:
			var item2_1 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(2) as ReferenceObject;
			var item2_2 : AnotherReferenceObject = new AnotherReferenceObject();
			item2_2.stringValue = "New value for another prop of item 2";
			item2_1.anotherReferenceObjectReference = item2_2;
			// case 2: 
			var item3_1 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(3) as ReferenceObject;
			item3_1.intValue = 300;
			var oldItem3_id : uint = item3_1.objectId;
			// case 3:
			var item5_1 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(5) as ReferenceObject;
			var new_item5_3 : SimpleObject = new SimpleObject();
			new_item5_3.intValue = 555;
			AnotherReferenceObject(item5_1.anotherReferenceObjectReference).reference = new_item5_3;
			// case 4:
			var item7_1 : ReferenceObject = objFromDB.referenceObjectsCollection.getItemAt(7) as ReferenceObject;
			var item7_3 : SimpleObject = AnotherReferenceObject(item7_1.anotherReferenceObjectReference).reference;
			item7_3.intValue = 777;
			
			entityManager.save(objFromDB);
			
			var loaded : CollectionObject = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			item2_1 = loaded.referenceObjectsCollection.getItemAt(2) as ReferenceObject;
			item2_2 = item2_1.anotherReferenceObjectReference as AnotherReferenceObject;
			assertEquals(item2_2.stringValue, "New value for another prop of item 2");
			item3_1 = loaded.referenceObjectsCollection.getItemAt(3) as ReferenceObject;
			assertEquals(item3_1.intValue, 300);
			assertEquals(item3_1.objectId, oldItem3_id);
			item5_1 = loaded.referenceObjectsCollection.getItemAt(5) as ReferenceObject;
			assertEquals(AnotherReferenceObject(item5_1.anotherReferenceObjectReference).reference.intValue, 555);
			item7_1 = loaded.referenceObjectsCollection.getItemAt(7) as ReferenceObject;
			assertEquals(AnotherReferenceObject(item7_1.anotherReferenceObjectReference).reference.intValue, 777);
			
			// PERSISTANT OBJECTS
			var persitantAnother : AnotherReferenceObject = (loaded.referenceObjectsCollection.getItemAt(9) as ReferenceObject).anotherReferenceObjectReference as AnotherReferenceObject;
			var item1_1 : ReferenceObject = loaded.referenceObjectsCollection.getItemAt(1) as ReferenceObject;
			item1_1.anotherReferenceObjectReference = persitantAnother;
			assertEquals(item1_1.anotherReferenceObjectReference.objectId, persitantAnother.objectId);
			var persistantSimple : SimpleObject = ((loaded.referenceObjectsCollection.getItemAt(4) as ReferenceObject).anotherReferenceObjectReference as AnotherReferenceObject).reference;
			var item6_1 : ReferenceObject = loaded.referenceObjectsCollection.getItemAt(6) as ReferenceObject;
			AnotherReferenceObject(item6_1.anotherReferenceObjectReference).reference = persistantSimple;
			
			entityManager.save(loaded);
			
			loaded = entityManager.getObject(objFromDB.objectId) as CollectionObject;
			item1_1 = loaded.referenceObjectsCollection.getItemAt(1) as ReferenceObject;
			assertEquals(item1_1.anotherReferenceObjectReference.objectId, persitantAnother.objectId);
			assertEquals(item1_1.anotherReferenceObjectReference.intValue, persitantAnother.intValue);
			item6_1 = loaded.referenceObjectsCollection.getItemAt(6) as ReferenceObject;
			assertEquals(AnotherReferenceObject(item6_1.anotherReferenceObjectReference).reference.objectId, persistantSimple.objectId);
			assertEquals(AnotherReferenceObject(item6_1.anotherReferenceObjectReference).reference.intValue, persistantSimple.intValue);
			
		}
		
		
		[Test]
		public function testItemsReferenceChainChanged() : void
		{
			// SAVE CHAINED COLLECTION
			var obj : CollectionObject = new CollectionObject();
			obj.collectionObjectsCollection = new ArrayCollection();
			for (var i : int = 0; i < 10; i++)
			{
				var item : CollectionObject = new CollectionObject();
				item.referenceObjectsCollection = createCollection(10*i);
				obj.collectionObjectsCollection.addItem(item);
			}
			entityManager.save(obj);
			var loaded : CollectionObject = entityManager.getObject(obj.objectId) as CollectionObject;
			
			assertNotNull(loaded);
			assertNotNull(loaded.collectionObjectsCollection);
			assertEquals(10, loaded.collectionObjectsCollection.length);
			var item5_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(5)).referenceObjectsCollection.getItemAt(3));
			assertEquals(item5_1.intValue, 53);
			var item5_2 : AnotherReferenceObject = item5_1.anotherReferenceObjectReference as AnotherReferenceObject;
			assertEquals(item5_2.stringValue, "Item No.53: Reference 2 (Another)");
			var item5_3 : SimpleObject = item5_2.reference;
			assertEquals(item5_3.stringValue, "Item No.53: Reference 3 (Simple)");
			// TEST
			// NEW OBJECTS:
			// case 1:
			var item23_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(2)).referenceObjectsCollection.getItemAt(3));
			var item23_2 : AnotherReferenceObject = new AnotherReferenceObject();
			item23_2.stringValue = "New value for another prop of item 2";
			item23_1.anotherReferenceObjectReference = item23_2;
			// case 2: 
			var item37_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(3)).referenceObjectsCollection.getItemAt(7));
			item37_1.intValue = 300;
			var oldItem37_id : uint = item37_1.objectId;
			// case 3:
			var item51_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(5)).referenceObjectsCollection.getItemAt(1));
			var new_item51_3 : SimpleObject = new SimpleObject();
			new_item51_3.intValue = 555;
			AnotherReferenceObject(item51_1.anotherReferenceObjectReference).reference = new_item51_3;
			// case 4:
			var item73_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(7)).referenceObjectsCollection.getItemAt(3));
			var item73_3 : SimpleObject = AnotherReferenceObject(item73_1.anotherReferenceObjectReference).reference;
			item73_3.intValue = 777;
			
			entityManager.save(loaded);
			
			loaded = entityManager.getObject(loaded.objectId) as CollectionObject;
			item23_1 = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(2)).referenceObjectsCollection.getItemAt(3));
			item23_2 = item23_1.anotherReferenceObjectReference as AnotherReferenceObject;
			assertEquals(item23_2.stringValue, "New value for another prop of item 2");
			item37_1 = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(3)).referenceObjectsCollection.getItemAt(7));
			assertEquals(item37_1.intValue, 300);
			assertEquals(item37_1.objectId, oldItem37_id);
			item51_1 = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(5)).referenceObjectsCollection.getItemAt(1));
			assertEquals(AnotherReferenceObject(item51_1.anotherReferenceObjectReference).reference.intValue, 555);
			item73_1 = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(7)).referenceObjectsCollection.getItemAt(3));
			assertEquals(AnotherReferenceObject(item73_1.anotherReferenceObjectReference).reference.intValue, 777);
			
			// PERSISTANT OBJECTS
			var persitantAnother : AnotherReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(9)).referenceObjectsCollection.getItemAt(1)).anotherReferenceObjectReference as AnotherReferenceObject;
			var item17_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(1)).referenceObjectsCollection.getItemAt(7));
			item17_1.anotherReferenceObjectReference = persitantAnother;
			assertEquals(item17_1.anotherReferenceObjectReference.objectId, persitantAnother.objectId);
			var persistantSimple : SimpleObject = ( ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(4)).referenceObjectsCollection.getItemAt(3)).anotherReferenceObjectReference as AnotherReferenceObject).reference;
			var item15_1 : ReferenceObject = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(1)).referenceObjectsCollection.getItemAt(5));
			AnotherReferenceObject(item15_1.anotherReferenceObjectReference).reference = persistantSimple;
			
			entityManager.save(loaded);
			
			loaded = entityManager.getObject(loaded.objectId) as CollectionObject;
			item17_1 = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(1)).referenceObjectsCollection.getItemAt(7));
			assertEquals(item17_1.anotherReferenceObjectReference.objectId, persitantAnother.objectId);
			assertEquals(item17_1.anotherReferenceObjectReference.intValue, persitantAnother.intValue);
			item15_1 = ReferenceObject(CollectionObject(loaded.collectionObjectsCollection.getItemAt(1)).referenceObjectsCollection.getItemAt(5));
			assertEquals(AnotherReferenceObject(item15_1.anotherReferenceObjectReference).reference.objectId, persistantSimple.objectId);
			assertEquals(AnotherReferenceObject(item15_1.anotherReferenceObjectReference).reference.intValue, persistantSimple.intValue);

			
		}
	}
}