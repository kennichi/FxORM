package cache
{
import IPersistentObject;

/**
 * Caches objects read from the DB, so that it does not need to read them again if there is a need for it, but can take them from cache.
 */
public class CacheManager
{
    private static var _instance : CacheManager;
    private static const MAX_CACHE_SIZE : int = 5000;
    private var objectsCacheSize : int = 0;
    // caches:
    private var objectsCache : Object = {};
    private var deletedObjectIds : Object = {};

    public static function get instance() : CacheManager {
        if (_instance == null) {
            _instance = new CacheManager();
        }
        return _instance;
    }

    public function reset() : void {
        objectsCache = {};
        objectsCacheSize = 0;
        deletedObjectIds = {};
    }

    public function removeObject(objectId : uint) : void {
        if (objectsCache[objectId] != null) {
            FxORM.instance.profiler.onObjectRemovedFromCache(objectsCache[objectId]);
        }
        objectsCache[objectId] = null;
    }

    public function getObject(objectId : uint) : IPersistentObject {
        var result:IPersistentObject = objectsCache[objectId] as IPersistentObject;
        if (result) {
            FxORM.instance.profiler.onObjectRetrievedFromCache(result);
        }
        return result;
    }

    /**
     * adds object to cache
     * @param object
     */
    public function setObject(object : IPersistentObject) : void {
        if (!object) return;


        objectsCache[object.objectId] = object;
        objectsCacheSize++;
        // todo: consider refactoring so that it increases only when object for a new id is added
        FxORM.instance.profiler.onObjectPutToCache(object);

        if (objectsCacheSize == MAX_CACHE_SIZE) {
            objectsCache = {};
            objectsCacheSize = 0;
        }
    }

    public function addDeletedId(id : uint) : void {
        deletedObjectIds[id] = true;
    }

    public function wasIdDeleted(id : uint) : Boolean {
        return deletedObjectIds[id] != null;
    }
}
}