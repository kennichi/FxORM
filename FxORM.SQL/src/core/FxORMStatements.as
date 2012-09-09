package core {
import IPersistentObject;

import flash.data.SQLStatement;

import utils.StringUtils;

import org.spicefactory.lib.reflect.ClassInfo;

public class FxORMStatements {
    private static const DELETE_FROM_OBJECTS_SQL : String = "DELETE FROM " + Constants.OBJECTS_TABLE + " WHERE ObjectId=:objectId";
    private static const DELETE_OBJECTS_FROM_COLLECTION_OBJECTS_SQL : String = "DELETE FROM " + Constants.COLLECTIONS_TABLE + " WHERE ObjectId IN ";
    private static const DELETE_FROM_COLLECTION_OBJECTS_SQL : String = "DELETE FROM " + Constants.COLLECTIONS_TABLE + " WHERE " + Constants.COLLECTION_ID_COLUMN_NAME + "=:collectionId";
    private static const INSERT_INTO_COLLECTION_OBJECTS_SQL : String = "INSERT INTO " + Constants.COLLECTIONS_TABLE + " (" + Constants.COLLECTION_ID_COLUMN_NAME + ", ObjectId) VALUES (:collectionId, :objectId)";
    private static const INSERT_INTO_OBJECTS_SQL : String = "INSERT INTO " + Constants.OBJECTS_TABLE + " (" + Constants.TYPE_NAME_COLUMN_NAME + ", " + Constants.BE_ID_COLUMN_NAME + ") VALUES (:typeName, :beId)";
    private static const GET_TYPE_NAME_SQL : String = "SELECT TypeName FROM " + Constants.OBJECTS_TABLE + " WHERE ObjectId=:objectId";
    private static const ALLOCATE_COLLECTION_ID_SQL : String = "INSERT INTO COLLECTIONS (temp) VALUES (0)";
    private static const SELECT_OBJECT_IDS_FROM_COLLECTION_SQL : String = "SELECT ObjectId FROM " + Constants.COLLECTIONS_TABLE + " WHERE " + Constants.COLLECTION_ID_COLUMN_NAME + "=:collectionId";
    private static const SELECT_OBJECT_FROM_COLLECTION_SQL : String = "SELECT {table}.* FROM {table} INNER JOIN " + Constants.COLLECTIONS_TABLE + " ON {table}."+Constants.ID_COLUMN_NAME+"=" + Constants.COLLECTIONS_TABLE + ".ObjectId WHERE " + Constants.COLLECTIONS_TABLE + "." + Constants.COLLECTION_ID_COLUMN_NAME + "=:collectionId";
    private static const SELECT_BE_OBJECT_SQL : String = "SELECT {table}.* FROM {table} INNER JOIN " + Constants.OBJECTS_TABLE + " ON {table}."+Constants.ID_COLUMN_NAME+"=" + Constants.OBJECTS_TABLE + ".ObjectId WHERE (("
            + Constants.OBJECTS_TABLE + "." + Constants.BE_ID_COLUMN_NAME + "=:beId) AND ("
            + Constants.OBJECTS_TABLE + "." + Constants.TYPE_NAME_COLUMN_NAME + "=:typeName))";
    private static const SELECT_BE_OBJECT_ID_SQL : String = "SELECT ObjectId FROM " + Constants.OBJECTS_TABLE + " WHERE (("
            + Constants.BE_ID_COLUMN_NAME + "=:beId) AND ("
            + Constants.TYPE_NAME_COLUMN_NAME + "=:typeName))";

    private var _deleteFromObjectsStatement : SQLStatement;
    private var _deleteFromCollectionObjectsStatement : SQLStatement;
    private var _insertIntoCollectionObjectsStatement : SQLStatement;
    private var _insertIntoObjectsStatement : SQLStatement;
    private var _getTypeNameByObjectIdStatement : SQLStatement;
    private var _allocateCollectionIdStatement : SQLStatement;
    private var _selectObjectIdsFromCollectionStatement : SQLStatement;
    private var _selectObjectIdWithBeIdStatement : SQLStatement;
    private var _selectObjectWithBeIdStatement : SQLStatement;

    public function deleteFromObjectsStatement(objectId : uint) : SQLStatement {
        if (_deleteFromObjectsStatement == null) {
            var deleteSQL : String = DELETE_FROM_OBJECTS_SQL;
            _deleteFromObjectsStatement = SqlStatementsFactory.create(deleteSQL);
        }
        _deleteFromObjectsStatement.parameters[":objectId"] = objectId;
        return _deleteFromObjectsStatement;
    }

    public function deleteFromCollectionObjectsStatement(collectionId : uint) : SQLStatement {
        if (_deleteFromCollectionObjectsStatement == null) {
            var deleteSQL : String = DELETE_FROM_COLLECTION_OBJECTS_SQL;
            _deleteFromCollectionObjectsStatement = SqlStatementsFactory.create(deleteSQL);
        }
        _deleteFromCollectionObjectsStatement.parameters[":collectionId"] = collectionId;
        return _deleteFromCollectionObjectsStatement;
    }

    public static function deleteObjectsFromCollectionObjectsStatement(objectIds : Array) : SQLStatement {
        var deleteSQL : String = DELETE_OBJECTS_FROM_COLLECTION_OBJECTS_SQL + "(" + objectIds.join(",") + ")";
        return SqlStatementsFactory.create(deleteSQL);
    }

    public static function selectRowsFromCollectionStatement(tableName : String,  collectionId : uint) : SQLStatement {
        var selectSQL : String = StringUtils.replace(SELECT_OBJECT_FROM_COLLECTION_SQL, tableName, "{table}");
        var statement : SQLStatement = SqlStatementsFactory.create(selectSQL);
        statement.parameters[":collectionId"] = collectionId;
        return statement;
    }

    public function insertIntoCollectionObjectsStatement(objectId : uint,  collectionId : uint) : SQLStatement {
        if (_insertIntoCollectionObjectsStatement == null) {
            var insertSQL : String = INSERT_INTO_COLLECTION_OBJECTS_SQL;
            _insertIntoCollectionObjectsStatement = SqlStatementsFactory.create(insertSQL);
        }
        _insertIntoCollectionObjectsStatement.parameters[":objectId"] = objectId;
        _insertIntoCollectionObjectsStatement.parameters[":collectionId"] = collectionId;
        return _insertIntoCollectionObjectsStatement;
    }

    /**
     * if instance has a separate id (i.e. from Back End), which is different from objectId generated by DM,
     * and which is unique only for instances of the instance's type, DM will store the beId as well as objectId and typeName in the OBJECTS table.
      */
    public function insertIntoObjectsStatement(instance : IPersistentObject, beId : String) : SQLStatement {
        if (_insertIntoObjectsStatement == null) {
            _insertIntoObjectsStatement = SqlStatementsFactory.create(INSERT_INTO_OBJECTS_SQL);
        }
        _insertIntoObjectsStatement.parameters[":typeName"] = ClassInfo.forInstance(instance).name;
        _insertIntoObjectsStatement.parameters[":beId"] = beId;
        return _insertIntoObjectsStatement;
    }

    public function getTypeNameByObjectIdStatement(objectId : uint) : SQLStatement {
        if (_getTypeNameByObjectIdStatement == null) {
            _getTypeNameByObjectIdStatement = SqlStatementsFactory.create(GET_TYPE_NAME_SQL);
        }
        _getTypeNameByObjectIdStatement.parameters[":objectId"] = objectId;
        return _getTypeNameByObjectIdStatement;
    }

    public function get allocateCollectionIdStatement() : SQLStatement {
        if (_allocateCollectionIdStatement == null) {
            _allocateCollectionIdStatement = SqlStatementsFactory.create(ALLOCATE_COLLECTION_ID_SQL);
        }
        return _allocateCollectionIdStatement;
    }

    public function selectObjectIdsFromCollectionStatement(collectionId : uint) : SQLStatement {
        if (_selectObjectIdsFromCollectionStatement == null) {
            _selectObjectIdsFromCollectionStatement = SqlStatementsFactory.create(SELECT_OBJECT_IDS_FROM_COLLECTION_SQL);
        }
        _selectObjectIdsFromCollectionStatement.parameters[":collectionId"] = collectionId;
        return _selectObjectIdsFromCollectionStatement;

    }

    public function selectObjectIdWithBeIdStatement(beId : String, typeName : String, tableName : String) : SQLStatement {
        var selectSQL : String = StringUtils.replace(SELECT_BE_OBJECT_ID_SQL, tableName, "{table}");
        if (_selectObjectIdWithBeIdStatement == null) {
            _selectObjectIdWithBeIdStatement = SqlStatementsFactory.create(selectSQL);
        }
        _selectObjectIdWithBeIdStatement.parameters[":beId"] = beId;
        _selectObjectIdWithBeIdStatement.parameters[":typeName"] = typeName;
        return _selectObjectIdWithBeIdStatement;

    }

    public function selectObjectWithBeIdStatement(beId : String, typeName : String, tableName : String) : SQLStatement {
        var selectSQL : String = StringUtils.replace(SELECT_BE_OBJECT_SQL, tableName, "{table}");
        if (_selectObjectWithBeIdStatement == null) {
            _selectObjectWithBeIdStatement = SqlStatementsFactory.create(selectSQL);
        }
        _selectObjectWithBeIdStatement.parameters[":beId"] = beId;
        _selectObjectWithBeIdStatement.parameters[":typeName"] = typeName;
        return _selectObjectWithBeIdStatement;
    }
}
}
