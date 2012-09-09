package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import contexts.CollectionAction;

import contexts.CollectionContext;

import core.utils.FxORMManager;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

import org.spicefactory.lib.errors.IllegalStateError;

import utils.PersistenceUtils;

use namespace data_mapping;

public class CommitCollectionChanges extends BaseEntityOperation {

    /**
     * saves collection which is already in the DB.
     * Commits all the changes made to the collection.
     * @param context
     * @return
     */
    public function execute(context : CollectionContext, pendingObjectsToSave : Array) : uint {
        var rawObject : Object = selectRawFromDB(context.owner);
        if (rawObject == null) {
            throw new IllegalStateError("SaveCollection should not be used for collections which are not already in the DB");
        }
        var collectionId : uint = rawObject[context.fieldName] as uint;
        var addedIds : Array = new Array();
        var removedIds : Array = new Array();
        for each (var action : CollectionAction in context.actions) {
            var item : IPersistentObject = action.item;
            if (!PersistenceUtils.existsInDB(item)) {
                operations.save(item, pendingObjectsToSave);
            }
            switch(action.actionType) {
                case CollectionAction.ADD_ACTION:
                    addedIds.push(item.objectId);
                    break;
                case CollectionAction.REMOVE_ACTION:
                    removedIds.push(item.objectId);
                    break;
            }
        }
        if (removedIds.length > 0) {
            FxORMManager.removeObjectsFromCollectionObjectsTable(removedIds, sqlConnection);
        }
        for each (var addId : uint in addedIds) {
            FxORMManager.insertIntoCollectionObjectsTable(addId,  collectionId, sqlConnection);
        }
        return collectionId;
    }

    public function CommitCollectionChanges(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
