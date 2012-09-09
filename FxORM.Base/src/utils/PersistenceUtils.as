package utils
{
import IPersistentObject;

import cache.CacheManager;

import namespaces.data_mapping;

use namespace data_mapping;
public class PersistenceUtils {

    private static const NON_PERSISTANT_IDS_START : uint = 0xF0000000;
    private static var _nonPersistantId : uint = NON_PERSISTANT_IDS_START;

    /**
     *
     * @param o
     * @return if {#link o} is stored in DB already.
     */
    public static function existsInDB(o : IPersistentObject) : Boolean {
        return isPersistantId(o.objectId);
    }

    public static function isPersistantId(objectId : uint) : Boolean {
        return objectId < NON_PERSISTANT_IDS_START && !CacheManager.instance.wasIdDeleted(objectId);
    }

    public static function areEqual(obj1 : Object, obj2 : Object) : Boolean {
        return obj1 == null && obj2 == null || ObjectUtils.areFxORMsEqual(obj1, obj2);
    }

    data_mapping static function allocateNonPersistantId() : uint {
        return _nonPersistantId++;
    }

}
}