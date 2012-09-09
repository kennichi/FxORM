package core.utils {
import core.Constants;
import core.utils.fieldMappings.FieldMappingFactory;
import core.utils.fieldMappings.SqlFieldMapping;

import utils.ArrayUtils;

import metadata.TableMetadata;

import org.spicefactory.lib.errors.IllegalStateError;

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

public class MetadataUtils {
    public static function getTableName(referenceType : Class) : String {
        var types:Array = getAllTypes(referenceType);
        for each (var clazz:Class in types) {
            var classInfo : ClassInfo = ClassInfo.forClass(clazz);
            var tableTags:Array = classInfo.getMetadata(TableMetadata);
            if (tableTags.length > 1) {
                throw new IllegalStateError("Class " + clazz + " has more than one [Table] metadata");
            }
            if (tableTags.length == 1) {
                return (tableTags[0] as TableMetadata).name;
            }
        }
        return null;
    }

    /**
     *
     * @param referenceType
     * @return map of @see FieldMapping by field name of {#link referenceType}
     */
    public static function getColumns(referenceType : Class) : Object {
        var result : Object = new Object();
        var types:Array = getAllTypes(referenceType);
        for each (var clazz : Class in types) {
            var classInfo : ClassInfo = ClassInfo.forClass(clazz);
            var properties : Array = classInfo.getProperties();
            for each(var property : Property in properties) {
                var field : SqlFieldMapping = FieldMappingFactory.create(property);
                // field is null if it does not have our metadata tags (Column, Id)
                if (field == null) continue;
                if (field.isId) {
                    result[Constants.ID_COLUMN_NAME] = field;
                } else {
                    result[property.name] = field;
                }
            }
        }
        return result;
    }

    /**
     *
     * @param referenceType
     * @return all types which this type is (all superclass + this type)
     */
    private static function getAllTypes(referenceType:Class):Array {
        var classInfo:ClassInfo = ClassInfo.forClass(referenceType);
        var superClasses:Array = classInfo.getSuperClasses();
        var classes:Array = ArrayUtils.joinArrays([
            [referenceType],
            superClasses
        ]);
        return classes;
    }
}
}
