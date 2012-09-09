package utils
{
import IPersistentObject;

public class ObjectUtils {
    public static function areFxORMsEqual(obj1 : *, obj2 : *) : Boolean {
        if (obj1 is IPersistentObject && obj2 is IPersistentObject && obj1 != null && obj2 != null) {
            return obj1.objectId == obj2.objectId;
        }
        return obj1 == obj2;
    }

    public static function getClassByInstance(o : Object) : Class {
        return o.constructor;
    }
}
}