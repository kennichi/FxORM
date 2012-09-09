package contexts
{
import IPersistentObject;

public class CollectionAction
{
    public static const ADD_ACTION : int = 0;
    public static const REMOVE_ACTION : int = 1;

    public var item : IPersistentObject;
    public var actionType : int;
    public function CollectionAction(actionType : int, item : IPersistentObject) {
        this.actionType = actionType;
        this.item = item;
    }
}
}