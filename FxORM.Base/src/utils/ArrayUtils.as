package utils
{
import mx.collections.ArrayCollection;

public class ArrayUtils
{
    public static function joinWithArray(array1 : Array, array2 : Array) : void {
        for each (var item : * in array2) {
            array1.push(item);
        }
    }

    public static function joinArrays(arrays: Array) : Array {
        var result : Array = [];
        for each (var arr : Array in arrays) {
            joinWithArray(result, arr);
        }
        return result;
    }

    public static function toArray(collection : Object) : Array {
        return collection is Array ? (collection as Array) : (collection is ArrayCollection ? ArrayCollection(collection).source : null);
    }

}
}