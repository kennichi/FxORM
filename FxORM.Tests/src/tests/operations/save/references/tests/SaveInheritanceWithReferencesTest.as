package tests.operations.save.references.tests
{
	import contexts.ReferenceContext;
	
	import data.AnotherReferenceObject;
	import data.ReferenceObject;
	import data.SimpleObject;
	
	import core.EntityManager;
	
	import flash.display.SimpleButton;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	
	import tests.BaseTest;
	
	import utils.PersistenceUtils;
	
	public class SaveInheritanceWithReferencesTest extends BaseTest
	{
		[Test]
		public function testReferenceInBaseClass_New() : void
		{
			trace("NEW TEST: testReferenceInBaseClass_New");
			var refObj : ReferenceObject = saveBaseReference();
			assertNotNull(refObj.simpleObjectReference);
			assertEquals(refObj.simpleObjectReference.intValue, 17);
			assertEquals(refObj.simpleObjectReference.midLevelProperty, "Child Test");
		}
		
		[Test]
		public function testReferenceInBaseClass_Persistant() : void
		{
			trace("NEW TEST: testReferenceInBaseClass_Persistant");
			var refObj : ReferenceObject = saveBaseReference();
			refObj.simpleObjectReference.intValue = 73;
			refObj.simpleObjectReference.midLevelProperty = "Different Value";
			entityManager.save(refObj);
			var referenceObjId : uint = refObj.simpleObjectReference.objectId;
			assertThat(referenceObjId > 0);
			var loaded : ReferenceObject = entityManager.getObject(refObj.objectId) as ReferenceObject;
			assertNotNull(refObj.simpleObjectReference);
			assertEquals(loaded.objectId, refObj.objectId);
			assertEquals(refObj.simpleObjectReference.intValue, 73);
			assertEquals(refObj.simpleObjectReference.midLevelProperty, "Different Value");
			assertEquals(refObj.simpleObjectReference.objectId, referenceObjId);
			var oldLoadedReference : SimpleObject = entityManager.getObject(referenceObjId) as SimpleObject;
			assertNotNull(oldLoadedReference);
			loaded.simpleObjectReference = null;
            entityManager.save(loaded);
			var reloaded : ReferenceObject = entityManager.getObject(loaded.objectId) as ReferenceObject;
			assertNotNull(reloaded);
			assertNull(reloaded.simpleObjectReference);
			reloaded.simpleObjectReference = oldLoadedReference;
			oldLoadedReference.intValue = 777;
            entityManager.save(reloaded);
			var rereloaded : ReferenceObject = entityManager.getObject(reloaded.objectId) as ReferenceObject;
			assertEquals(rereloaded.simpleObjectReference.intValue, 777); 
		}
		
		[Test]
		public function testReferenceInChildClass_New() : void
		{
			trace("NEW TEST: testReferenceInChildClass_New");
			var refObj : ReferenceObject = saveChildReference();
			assertTrue(PersistenceUtils.existsInDB(refObj));
//			assertTrue(refObj.objectId > 0);			
			assertNotNull(refObj.anotherReferenceObjectReference);
			assertNotNull(refObj.referenceObjectReference);
			assertEquals(refObj.referenceObjectReference.simpleObjectReference.floatValue,  0.342);
			assertEquals(refObj.referenceObjectReference.intValue, 989);
			var anotherReferenceObjectReference : AnotherReferenceObject = AnotherReferenceObject(refObj.anotherReferenceObjectReference);
			
			assertEquals(anotherReferenceObjectReference.floatValue, 3.14159);
			assertEquals(anotherReferenceObjectReference.stringValue, "Another Object");
			assertEquals(anotherReferenceObjectReference.reference.intValue, 18);
			assertEquals(anotherReferenceObjectReference.reference.midLevelProperty, "ReferencedAnotherObjectsSimplesProperty");
		}
		
		[Test]
		public function testReferenceInChildClass_Persistant() : void
		{
			trace("NEW TEST: testReferenceInChildClass_Persistant");
			var refObj : ReferenceObject = saveChildReference();
			refObj.referenceObjectReference = null;
			refObj.anotherReferenceObjectReference.floatValue = 0.3332;
			var simpleObj : SimpleObject = new SimpleObject();
			simpleObj.intValue = 12;
			simpleObj.midLevelProperty = "New Mid Value";
			AnotherReferenceObject(refObj.anotherReferenceObjectReference).reference = simpleObj;
			entityManager.save(refObj);
			var loaded : ReferenceObject = entityManager.getObject(refObj.objectId) as ReferenceObject;
			assertNull(refObj.referenceObjectReference);
			assertNotNull(refObj.anotherReferenceObjectReference);
			assertTrue(refObj.anotherReferenceObjectReference.floatValue, 0.3332);
			var simpleLoaded : SimpleObject = AnotherReferenceObject(refObj.anotherReferenceObjectReference).reference;
			assertTrue(PersistenceUtils.existsInDB(simpleLoaded));
//			assertTrue(simpleLoaded.objectId > 0);
			assertEquals(simpleLoaded.intValue, 12);
			assertEquals(simpleLoaded.midLevelProperty, "New Mid Value");
		}
//		
//		[Test]
//		public function testReferencedHierarchy() : void
//		{
//			
//		}
//		
//		[Test]
//		public function testSimpleValuesInBaseClass() : void
//		{
//			
//		}
//		
//		[Test]
//		public function testSimpleValuesInChildClass() : void
//		{
//			
//		}
		
		private function saveChildReference() : ReferenceObject
		{
			entityManager.beginTran();
			var refObj : ReferenceObject = new ReferenceObject();
			refObj.referenceObjectReference = new ReferenceObject();
			var simpleObject : SimpleObject = new SimpleObject();
			simpleObject.floatValue = 0.342;
			refObj.referenceObjectReference.simpleObjectReference = simpleObject;
			refObj.referenceObjectReference.intValue = 989;
			var anotherReferenceObjectReference : AnotherReferenceObject = new AnotherReferenceObject();
			anotherReferenceObjectReference.floatValue = 3.14159;
			anotherReferenceObjectReference.stringValue = "Another Object";
			anotherReferenceObjectReference.reference = new SimpleObject();
			anotherReferenceObjectReference.reference.intValue = 18;
			anotherReferenceObjectReference.reference.midLevelProperty = "ReferencedAnotherObjectsSimplesProperty";
			refObj.anotherReferenceObjectReference = anotherReferenceObjectReference;
			entityManager.save(refObj);
			entityManager.commitTran();
			return entityManager.getObject(refObj.objectId) as ReferenceObject;
		}
		
		
		private function saveBaseReference() : ReferenceObject
		{
			var refObj : ReferenceObject = new ReferenceObject();
			refObj.simpleObjectReference = new SimpleObject();
			refObj.simpleObjectReference.intValue = 17;
			refObj.simpleObjectReference.midLevelProperty = "Child Test";
			entityManager.save(refObj);
			return entityManager.getObject(refObj.objectId) as ReferenceObject;
		}
	}
}