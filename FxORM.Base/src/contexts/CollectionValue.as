package contexts
{
/**
 * FieldValue extended for storing collections of reference objects. The values stored instances of @see CollectionContext.
 */
public class CollectionValue extends FieldValue
{
    public function get context() : CollectionContext {
        return value as CollectionContext;
    }

    public function set context(val : CollectionContext) : void {
        value = val;
    }

}
}