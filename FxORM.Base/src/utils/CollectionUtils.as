package utils
{
import mx.collections.ICollectionView;
import mx.collections.ListCollectionView;

public class CollectionUtils
{
    public static function remove(collection : ListCollectionView, item : *) : Boolean {
        if (isEmpty(collection)) return false;
        var index : int = collection.getItemIndex(item);
        if (index == -1) return false;
        collection.removeItemAt(index);
        return true;
    }

    public static function isEmpty(collection : ICollectionView) : Boolean {
        return collection == null || collection.length == 0;
    }
}
}