package tests.operations.save.references.tests
{
	import data.AnotherReferenceObject;
	import data.ReferenceObject;
	import data.SimpleObject;
	
	import core.EntityManager;
	
	import flash.display.SimpleButton;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	
	import tests.BaseTest;

	public class SaveReferenceChainTest extends BaseTest
	{		
		[Test]
		public function testSaveNewReferenceChain() : void
		{
			var loaded : ReferenceObject = saveAndLoadChain();
			assertEquals(loaded.floatValue, 0.23223);
			assertEquals(loaded.intValue, 123);
			assertEquals(loaded.dateValue.date, 17);
			assertEquals(loaded.dateValue.month, 6);
			assertEquals(loaded.simpleValueField, "Reference Object's Simple Value");
			var another : AnotherReferenceObject = loaded.anotherReferenceObjectReference as AnotherReferenceObject;
			assertNotNull(another);
			assertEquals(another.date.month, 2);
			assertEquals(another.date.date, 12);
			assertEquals(another.intValue, 232);
			var simple : SimpleObject = another.reference;
			assertNotNull(simple);
			assertEquals(simple.floatValue, 324.34322);
			assertEquals(simple.midLevelProperty, "Simple Property");
			assertEquals(loaded.referenceObjectReference.simpleValueField, "Reference 1.5");
			assertEquals(loaded.referenceObjectReference.referenceObjectReference.simpleValueField, "Reference 2");
			assertEquals(loaded.referenceObjectReference.referenceObjectReference.anotherReferenceObjectReference.stringValue, "Another 2");
			assertEquals(AnotherReferenceObject(loaded.referenceObjectReference.referenceObjectReference.anotherReferenceObjectReference).reference.stringValue, "Simple 3");
			
		}
		
		private function saveAndLoadChain() : ReferenceObject
		{
			var refObj : ReferenceObject = new ReferenceObject();
			refObj.floatValue = 0.23223;
			refObj.intValue = 123;
			refObj.dateValue = new Date(1984, 6, 17);
			refObj.simpleValueField = "Reference Object's Simple Value";
			
			var another : AnotherReferenceObject = new AnotherReferenceObject();
			another.intValue = 232;
			another.date = new Date(2011, 2, 12, 0,0,0,0);
			
			var simple : SimpleObject = new SimpleObject();
			simple.floatValue = 324.34322;
			simple.midLevelProperty = "Simple Property";
			
			another.reference = simple;
			refObj.anotherReferenceObjectReference = another;
			
			
			var ref2 : ReferenceObject = new ReferenceObject();
			ref2.simpleValueField = "Reference 2";
			var another2 : AnotherReferenceObject = new AnotherReferenceObject();
			another2.stringValue = "Another 2";
			var simple2 : SimpleObject = new SimpleObject();
			simple2.stringValue = "Simple 3";
			another2.reference = simple2;
			ref2.anotherReferenceObjectReference = another2;
			
			var ref3 : ReferenceObject = new ReferenceObject();
			ref3.simpleValueField = "Reference 1.5";
			ref3.referenceObjectReference = ref2;
			refObj.referenceObjectReference = ref3;
			
			entityManager.save(refObj);
			var loaded : ReferenceObject = entityManager.getObject(refObj.objectId) as ReferenceObject;
			return loaded;
		}
		
		[Test]
		public function testSaveChangedPersistantReferenceChainToPersistanceObjs() : void
		{
			// case 1:
			var loaded : ReferenceObject = saveAndLoadChain();
			var simpleToPersist : SimpleObject = new SimpleObject();
			simpleToPersist.intValue = 234;
			entityManager.save(simpleToPersist);
			AnotherReferenceObject(loaded.anotherReferenceObjectReference).reference = simpleToPersist;
			entityManager.save(loaded);
			var reloaded : ReferenceObject = entityManager.getObject(loaded.objectId) as ReferenceObject;
			assertEquals(AnotherReferenceObject(reloaded.anotherReferenceObjectReference).reference.intValue, 234);
			AnotherReferenceObject(reloaded.anotherReferenceObjectReference).reference.intValue = 111;
			reloaded.referenceObjectReference.referenceObjectReference.simpleValueField = "Changed";
			entityManager.save(reloaded);
			reloaded = entityManager.getObject(loaded.objectId) as ReferenceObject;
			assertEquals(AnotherReferenceObject(reloaded.anotherReferenceObjectReference).reference.intValue, 111);
			assertEquals(reloaded.referenceObjectReference.referenceObjectReference.simpleValueField , "Changed");
			// while writing case 1 I forgot what I wanted in case 2...... :-/
		}
		
		[Test]
		public function testSaveChangedPersistantReferenceChainToNewObjs() : void
		{
			var loaded : ReferenceObject = saveAndLoadChain();
			var simpleToPersist1 : SimpleObject = new SimpleObject();
			simpleToPersist1.intValue = 1;
			var simpleToPersist2 : SimpleObject = new SimpleObject();
			simpleToPersist2.intValue = 2;
			AnotherReferenceObject(loaded.anotherReferenceObjectReference).reference = simpleToPersist1;
			loaded.referenceObjectReference.referenceObjectReference.simpleObjectReference = simpleToPersist2;
			entityManager.save(loaded);
			var realoaded : ReferenceObject = entityManager.getObject(loaded.objectId) as ReferenceObject;
			assertEquals(AnotherReferenceObject(loaded.anotherReferenceObjectReference).reference.intValue, 1);
			assertEquals(loaded.referenceObjectReference.referenceObjectReference.simpleObjectReference.intValue, 2);			
		}
		
		[Test]
		public function testSavePersitantItemInReferenceChainSetToNull() : void
		{
			var loaded : ReferenceObject = saveAndLoadChain();
			assertNotNull(loaded.referenceObjectReference.referenceObjectReference.anotherReferenceObjectReference);
			loaded.referenceObjectReference.referenceObjectReference.anotherReferenceObjectReference = null;
			entityManager.save(loaded);
			assertNull(loaded.referenceObjectReference.referenceObjectReference.anotherReferenceObjectReference);
		}
		
		[Test]
		public function testSavePersistanReferenceChainAddedReferences() : void
		{
			var loaded : ReferenceObject = saveAndLoadChain();
			var ref2 : ReferenceObject = new ReferenceObject();
			ref2.intValue = 256;
			loaded.referenceObjectReference.referenceObjectReference.referenceObjectReference = ref2;
			entityManager.save(loaded);
			var reloaded : ReferenceObject = entityManager.getObject(loaded.objectId) as ReferenceObject;
			assertNotNull(reloaded.referenceObjectReference.referenceObjectReference.referenceObjectReference);
			assertEquals(reloaded.referenceObjectReference.referenceObjectReference.referenceObjectReference.intValue, 256);
		}
		
	}
}