package tests.operations.save.references.tests
{
	import data.AnotherReferenceObject;
	import data.ReferenceObject;
	
	import core.EntityManager;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	
	import tests.BaseTest;
	
	import utils.PersistenceUtils;

	public class SaveNullReferenceTest extends BaseTest
	{
		[Test]
		public function saveNewObjectWithNullReference() : void
		{
			var ref : ReferenceObject = new ReferenceObject();
			entityManager.save(ref);
			assertTrue(PersistenceUtils.existsInDB(ref));
//			assertTrue(ref.objectId > 0);
			var loaded : ReferenceObject = entityManager.getObject(ref.objectId) as ReferenceObject;
			assertNull(loaded.anotherReferenceObjectReference);
		}
		[Test]
		public function setSetPersistantsObjRefToNullTest() : void 
		{
			var ref : ReferenceObject = new ReferenceObject();
			var ref2 : ReferenceObject = new ReferenceObject();
			ref.referenceObjectReference = ref2;
			entityManager.save(ref);
			var loaded : ReferenceObject = entityManager.getObject(ref.objectId) as ReferenceObject;
			assertNotNull(loaded.referenceObjectReference);
			loaded.referenceObjectReference = null;
			entityManager.save(loaded);
			var reloaded : ReferenceObject = entityManager.getObject(loaded.objectId) as ReferenceObject;
			assertNull(reloaded.referenceObjectReference);
		}
	}
}