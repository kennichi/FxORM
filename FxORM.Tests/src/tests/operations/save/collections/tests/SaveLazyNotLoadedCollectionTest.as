package tests.operations.save.collections.tests {
import cache.CacheManager;
import data.CollectionObject;
import org.hamcrest.assertThat;

import tests.operations.save.collections.tests.CollectionTestBase;

public class SaveLazyNotLoadedCollectionTest extends CollectionTestBase {

    [Test]
    public function test() {
        var collectionObject : CollectionObject = createSimpleCollectionObject();
        collectionObject.save();
        CacheManager.instance.reset();
        var fromDB1:IPersistentObject = FxORM.instance.entityManager.getObject(collectionObject.objectId);
        fromDB1.save();
        var fromDB2:CollectionObject = CollectionObject(FxORM.instance.entityManager.getObject(collectionObject.objectId));
        assertThat(fromDB2.referenceObjectsCollection.length > 0)
    }
}
}
