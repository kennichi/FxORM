package core.utils.fieldMappings {
import core.Constants;

import utils.StringUtils;

import metadata.ColumnMetadata;
import metadata.IdMetadata;
import org.spicefactory.lib.errors.IllegalStateError;

import org.spicefactory.lib.reflect.Property;

public class FieldMappingFactory {
    public static function create(property : Property) : SqlFieldMapping {
        var columnTags : Array = property.getMetadata(ColumnMetadata);
        var isId : Boolean = property.getMetadata(IdMetadata).length > 0;
        if (isId) {
            if (columnTags.length > 0) {
                throw new IllegalStateError("Do not add [Column] tags to [Id] properties");
            }
            if (property.type.name != "uint") {
                throw new IllegalStateError("All [Id] properties must be of type uint");
            }
            return new IdFieldMapping(property.name, Constants.ID_COLUMN_NAME);
        }
        else if (columnTags.length > 0) {
            if (columnTags.length > 1) {
                throw new IllegalStateError("property can have only one [Column] metadata");
            }
            var columnTag : ColumnMetadata = columnTags[0] as ColumnMetadata;
            var typeName : String = property.type.name;
            validateColumnTag(columnTag, typeName, property.name);
            if (columnTag.isReference) {
                if (columnTag.referenceType != null) typeName = columnTag.referenceType;
                return new ReferenceFieldMapping(property.name, columnTag.name, typeName, columnTag.lazyLoad, columnTag.isCascade);
            }
            if (columnTag.isCollection) {
                return new CollectionFieldMapping(property.name, columnTag.name, typeName, columnTag.lazyLoad, columnTag.isCascade, columnTag.collectionItemType);
            }
            switch(typeName) {
                case "Date":
                    return new DateFieldMapping(property.name, columnTag.name);
                case "Boolean":
                    return new BooleanFieldMapping(property.name, columnTag.name);
                case "Array":
                    return new ArrayFieldMapping(property.name, columnTag.name, columnTag.collectionItemType);
                default:
                    if (typeIsArrayCollection(typeName)) {
                        return new ArrayCollectionFieldMapping(property.name, columnTag.name, columnTag.collectionItemType);
                    }
                    return new PrimitiveFieldMapping(property.name, columnTag.name, typeName);
            }
        }
        return null;
    }

    private static function validateColumnTag(columnTag:ColumnMetadata, typeName : String, propertyName : String):void {
        if ((columnTag.isCascade) && !(columnTag.isReference || columnTag.isCollection)) {
            throw new IllegalStateError("isCascade and lazyLoad can be set only for isReference and isCollection columns. Property " + propertyName + " of type " + typeName);
        }
        if (!StringUtils.isEmpty(columnTag.collectionItemType) && !columnTag.isCollection && !typeIsCollection(typeName)) {
            throw new IllegalStateError("collectionItemType can be set only for isCollection properties or for Array/ArrayCollection properties of primitive items. Property " + propertyName + " of type " + typeName);
        }
        if (!StringUtils.isEmpty(columnTag.referenceType) && !columnTag.isReference) {
            throw new IllegalStateError("referenceType can be set only for isReference columns. Property " + propertyName + " of type " + typeName);
        }
        if (columnTag.isCollection && columnTag.isReference) {
            throw new IllegalStateError("property cannot be isCollection and isReference at the same time. Property " + propertyName + " of type " + typeName);
        }
    }

    private static function typeIsCollection(type : String) : Boolean {
        return type == "Array" || typeIsArrayCollection(type);
    }

    private static function typeIsArrayCollection(type:String):Boolean {
        return type == "ArrayCollection" || type == "mx.collections::ArrayCollection";
    }
}
}
