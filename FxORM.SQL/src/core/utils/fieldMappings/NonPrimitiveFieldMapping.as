package core.utils.fieldMappings {
public class NonPrimitiveFieldMapping extends SqlFieldMapping {
    public var lazyLoad : Boolean;
    /**
     * when the referenced property/collection is an aggregate, it may exist only in the context of its owner. Which means that if the
     * owner is deleted from the DB, the aggregated property/collection will be deleted as well.
     */
    public var isCascade : Boolean;

    public function NonPrimitiveFieldMapping(fieldName:String, columnName:String, typeName:String, lazyLoad:Boolean, isCascade:Boolean) {
        super(fieldName, columnName, typeName);
        this.lazyLoad = lazyLoad;
        this.isCascade = isCascade;
    }
}
}
