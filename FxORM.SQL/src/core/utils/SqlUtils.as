package core.utils {
import flash.data.SQLColumnSchema;
import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLSchemaResult;
import flash.data.SQLStatement;
import flash.data.SQLTableSchema;
import utils.StringUtils;

public class SqlUtils {

    public static function execute(statement : SQLStatement, sqlConnection : SQLConnection) : SQLResult {
        var start : Number = new Date().milliseconds;
        statement.sqlConnection = sqlConnection;
        if (StringUtils.isEmpty(statement.text)) {
            return null;
        }
        try {
            statement.execute();
        }
        catch(e : Error) {
            FxORM.instance.profiler.onQuery(statement.text, statement.parameters, elapsed(start), 0);
            FxORM.instance.profiler.onError(e.message);
            throw e;
        }
        var result:SQLResult = statement.getResult();
        FxORM.instance.profiler.onQuery(statement.text, statement.parameters, elapsed(start), result.rowsAffected);
        return result;
    }

    private static function elapsed(from : Number) : Number {
        return new Date().milliseconds - from;
    }

    public static function executeWithResult(statement : SQLStatement, sqlConnection : SQLConnection) : Array {
        return execute(statement, sqlConnection).data;
    }

    /**
     *
     * @param tableName
     * @return  null if no such table exists, empty obj if table does not contain any fields,
     * map of cols if it contains some
     */
    public static function getDBColumnsMap(tableName : String, schema : SQLSchemaResult) : Object {
        var result : Object;
        for each (var table : SQLTableSchema in schema.tables) {
            if (table.name != tableName) continue;
            result = new Object();
            for each (var column : SQLColumnSchema in table.columns) {
                result[column.name] = column.dataType;
            }
        }
        return result;
    }

    public static function getSQLType(asType : String) : String {
        if (asType == "int" || asType == "uint" || asType == "Date")
            return "INTEGER";
        else if (asType == "Number")
            return "REAL";
        else if (asType == "flash.utils::ByteArray")
            return "BLOB";
        else
            return "TEXT";
    }
}
}
