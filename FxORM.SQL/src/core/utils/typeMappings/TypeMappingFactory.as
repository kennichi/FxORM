package core.utils.typeMappings {
import core.typeMappingSqlBuilders.ReferenceInsertStubSqlBuilder;
import core.utils.*;
import core.Constants;
import core.SqlStatementsFactory;
import core.typeMappingSqlBuilders.IReferenceSqlStatementsBuilder;
import core.typeMappingSqlBuilders.ReferenceDeleteSqlBuilder;
import core.typeMappingSqlBuilders.ReferenceInsertSqlBuilder;
import core.typeMappingSqlBuilders.ReferenceSelectSqlBuilder;
import core.typeMappingSqlBuilders.ReferenceUpdateSqlBuilder;
import core.typeMappingSqlBuilders.ReferenceUpdateTableSqlBuilder;
import core.utils.fieldMappings.SqlFieldMapping;

import flash.data.SQLConnection;
import flash.data.SQLSchemaResult;
import flash.data.SQLStatement;

import metadata.TypeMapping;

import utils.StringUtils;

public class TypeMappingFactory {
    private var _sqlConnection : SQLConnection;
    private var _schema : SQLSchemaResult;

    public function TypeMappingFactory() {
    }

    public function create(referenceType : Class, sqlConnection : SQLConnection) : TypeMapping {
        this.sqlConnection = sqlConnection;
        var typeMapping : TypeMapping = new TypeMapping();

        var tableName : String = MetadataUtils.getTableName(referenceType);
        var fieldColumns : Object = MetadataUtils.getColumns(referenceType);
        var dbColumns : Object = SqlUtils.getDBColumnsMap(tableName, schema);

        typeMapping.table = tableName;
        typeMapping.fields = new Array();
        for (var field : String in fieldColumns) {
            var fieldMapping : SqlFieldMapping = fieldColumns[field] as SqlFieldMapping;
            typeMapping.fields.push(fieldMapping);
        }
        typeMapping.insertStatement = getSql(new ReferenceInsertSqlBuilder(), false);
        typeMapping.insertStubStatement = getSql(new ReferenceInsertStubSqlBuilder(), false);
        typeMapping.updateStatement = getSql(new ReferenceUpdateSqlBuilder(), true);
        typeMapping.deleteStatement = getSql(new ReferenceDeleteSqlBuilder(), true);
        typeMapping.findAllStatement = getSql(new ReferenceSelectSqlBuilder(), false);
        typeMapping.getByIdStatement = getSql(new ReferenceSelectSqlBuilder(), true);


        var updateTableStatementSqls : Array = new ReferenceUpdateTableSqlBuilder().build(tableName, fieldColumns, dbColumns);
        typeMapping.updateTableStatements = updateTableStatementSqls;

        return typeMapping;

        function getSql(builder : IReferenceSqlStatementsBuilder, selectById : Boolean = false) : String {
            var sql : String = builder.build(tableName, fieldColumns, dbColumns)[0];
            if (StringUtils.isEmpty(sql)) return "";
            if (selectById) {
                sql += " WHERE " + Constants.ID_COLUMN_NAME + "=:objectId";
            }
            return sql;
        }
    }

    public function set sqlConnection(value:SQLConnection):void {
        if (_sqlConnection == value) return;
        _sqlConnection = value;
        _schema = null;
    }

    private function get schema() : SQLSchemaResult
    {
        if (_schema == null) {
            _sqlConnection.loadSchema();
            _schema = _sqlConnection.getSchemaResult();
        }
        return _schema;
    }

}
}
