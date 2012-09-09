package tests.operations.save.primitives.tests
{
import tests.operations.save.primitives.*;

import cache.CacheManager;

import data.SimpleObject;
	import data.SimpleObjectChild;

	import tests.TestUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;

	public class SaveSimpleObjectInheritanceTest extends SimpleObjectTestBase
	{		
		[Test]
		public function testTableInBaseClass() : void
		{
			var child : SimpleObjectChild = new SimpleObjectChild();
			child.childValue = "Child Property";
			child.midLevelProperty = "Mid Property";
			child.stringValue = "String Property";
			child.intValue = 12;
			entityManager.save(child);
            CacheManager.instance.reset();

            var loaded : Array = entityManager.findAll(SimpleObjectChild);
			TestUtils.assertCollection(new ArrayCollection(loaded), 1, SimpleObjectChild);
			var loadedObj : SimpleObjectChild = loaded[0] as SimpleObjectChild;
			assertEquals(loadedObj.childValue, "Child Property");
			assertEquals(loadedObj.midLevelProperty, "Mid Property");
			assertEquals(loadedObj.stringValue, "String Property");
			assertEquals(loadedObj.intValue, 12);
		}
		
		[Test]
		public function testTableInChildClass() : void
		{
			var child : SimpleObject = new SimpleObject();
			child.midLevelProperty = "Mid Property";
			child.stringValue = "String Property";
			child.intValue = 12;
			entityManager.save(child);
            CacheManager.instance.reset();

            var loaded : Array = entityManager.findAll(SimpleObject);
			TestUtils.assertCollection(new ArrayCollection(loaded), 1, SimpleObject);
			var loadedObj : SimpleObject = loaded[0] as SimpleObject;
			assertEquals(loadedObj.midLevelProperty, "Mid Property");
			assertEquals(loadedObj.stringValue, "String Property");
			assertEquals(loadedObj.intValue, 12);
		}
		
		[Test]
		public function testColumnInBaseClass() : void
		{
			var child : SimpleObjectChild = new SimpleObjectChild();
			child.intValue = 12;
			entityManager.save(child);
            CacheManager.instance.reset();
			var loaded : Array = entityManager.findAll(SimpleObjectChild);
			TestUtils.assertCollection(new ArrayCollection(loaded), 1, SimpleObjectChild);
			var loadedObj : SimpleObject = loaded[0] as SimpleObject;
			assertEquals(loadedObj.intValue, 12);
		}
		
		[Test]
		public function testColumnInChildClass() : void
		{
			var child : SimpleObjectChild = new SimpleObjectChild();
			child.childValue = "Child Property";
			entityManager.save(child);
            CacheManager.instance.reset();
            var loaded : Array = entityManager.findAll(SimpleObjectChild);
			TestUtils.assertCollection(new ArrayCollection(loaded), 1, SimpleObjectChild);
			var loadedObj : SimpleObjectChild = loaded[0] as SimpleObjectChild;
			assertEquals(loadedObj.childValue, "Child Property");
		}
	}
}