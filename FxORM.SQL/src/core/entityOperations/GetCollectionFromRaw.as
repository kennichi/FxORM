package core.entityOperations {
import cache.CacheManager;

import core.utils.FxORMManager;
import core.utils.DataUtils;
import core.utils.fieldMappings.CollectionFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

import metadata.TypeMapping;

import mx.collections.ArrayCollection;

use namespace data_mapping;
public class GetCollectionFromRaw extends BaseEntityOperation{
    /**
     *
     * @param raw selection from DB of the collection owner object
     * @param field field describing this collection
     * @return either Array or ArrayCollection of PersistentObjects stored in collection specified by {#link field},
     * and referenced by {#link raw}
     */
    public function execute(raw : Object, field : CollectionFieldMapping) : * {
        var  val : * = raw[field.columnName];
        if (val == null  || val == 0) {
            return null;
        }
        else {
            var collId : uint = val as uint;
            var collectionItemClass : Class = DataUtils.getClass(field.collectionItemType);
            var collectionClass : Class = DataUtils.getClass(field.typeName);
            var objects : Array = getCollectionObjectReferences(collId, collectionItemClass);
            var result : * = new collectionClass();
            if (result is Array) {
                return objects;
            }
            else if (result is ArrayCollection) {
                ArrayCollection(result).source = objects;
            }
            return result;
        }
    }

    /**
     *
     * @param collectionId id of collection
     * @param collectionItemClass class, extends IPersistentObject
     * @return Array of {#link collectionItemClass} items from DB for the collection with id {#link collectionId}.
     */
    private function getCollectionObjectReferences(collectionId : uint, collectionItemClass : Class) : Array {
        var mapping : TypeMapping = getMapping(collectionItemClass);
        var objectsRows : Array = FxORMManager.selectObjectRowsFromCollection(mapping.table, collectionId, sqlConnection);
        var result : Array = new Array();
        for each (var object : * in objectsRows) {
            result.push(operations.convertObject(object, collectionItemClass));
        }
        return result;
    }

    public function GetCollectionFromRaw(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
