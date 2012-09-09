package core.utils {
import IPersistentObject;

import core.FxORMStatements;

import flash.data.SQLConnection;

import interfaces.IDuplicatedReference;

import namespaces.data_mapping;

use namespace data_mapping;

public class FxORMManager {
     private static var statements : FxORMStatements = new FxORMStatements();

    /**
     *
     * @param sqlConnection
     * @return returns collection id for new collection
     */
    data_mapping static function allocateCollectionId(sqlConnection : SQLConnection) : uint {
        return SqlUtils.execute(statements.allocateCollectionIdStatement, sqlConnection).lastInsertRowID;
    }

    data_mapping static function allocatePersistantObjectId(o : IPersistentObject, sqlConnection : SQLConnection) : uint {
        var id : String = null;
        if (o is IDuplicatedReference)
        {
            var beId : * = IDuplicatedReference(o).idField;
            if (beId == 0 || beId == null || beId == "") id = null;
            else id = String(beId);
        }
        return SqlUtils.execute(statements.insertIntoObjectsStatement(o, id), sqlConnection).lastInsertRowID;
    }

    data_mapping static function getTypeNameById(objectId : uint, sqlConnection : SQLConnection) : String {
        return SqlUtils.executeWithResult(statements.getTypeNameByObjectIdStatement(objectId), sqlConnection)[0].TypeName;
    }

    data_mapping static function removeFromObjectsTable(objectId : uint, sqlConnection : SQLConnection) : void {
        SqlUtils.execute(statements.deleteFromObjectsStatement(objectId), sqlConnection);
    }

    data_mapping static function removeFromCollectionObjectsTable(collectionId : uint, sqlConnection : SQLConnection) : void {
        SqlUtils.execute(statements.deleteFromCollectionObjectsStatement(collectionId), sqlConnection);
    }

    data_mapping static function insertIntoCollectionObjectsTable(objectId : uint,  collectionId : uint, sqlConnection : SQLConnection) : void {
        SqlUtils.execute(statements.insertIntoCollectionObjectsStatement(objectId, collectionId), sqlConnection);
    }

    data_mapping static function removeObjectsFromCollectionObjectsTable(objectIds : Array, sqlConnection : SQLConnection) : void {
        SqlUtils.execute(FxORMStatements.deleteObjectsFromCollectionObjectsStatement(objectIds), sqlConnection);
    }

    data_mapping static function selectObjectRowsFromCollection(table : String, collectionId : uint, sqlConnection : SQLConnection) : Array {
        return SqlUtils.executeWithResult(FxORMStatements.selectRowsFromCollectionStatement(table, collectionId), sqlConnection);
    }

    data_mapping static function selectObjectIdsFromCollection(collectionId : uint, sqlConnection : SQLConnection) : Array {
        var queryResult : Array = SqlUtils.executeWithResult(statements.selectObjectIdsFromCollectionStatement(collectionId), sqlConnection);
        var result : Array = [];
        for each (var obj : Object in queryResult)
        {
            result.push(obj.ObjectId);
        }
        return result;
    }

    /**
     *
     * @param beId
     * @param type
     * @param sqlConnection
     * @return raw object from DB with beId and type as {#link beId} and {#link type}
     */
    data_mapping static function selectObjectByBeId(beId : String, typeName : String, table : String, sqlConnection : SQLConnection) : Object {
        var result:Array = SqlUtils.executeWithResult(statements.selectObjectWithBeIdStatement(beId, typeName, table), sqlConnection);
        return result && result.length == 1 ? result[0] : null;
    }

    data_mapping static function selectObjectIdByBeId(beId : String,  typeName : String, table : String, sqlConnection : SQLConnection) : uint {
        var result:Array = SqlUtils.executeWithResult(statements.selectObjectIdWithBeIdStatement(beId, typeName, table), sqlConnection);
        return result && result.length == 1 ? result[0].ObjectId : 0;
    }
}
}
