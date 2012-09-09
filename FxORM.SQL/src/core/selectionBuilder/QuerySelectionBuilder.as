package core.selectionBuilder {
import core.Constants;
import core.SqlStatementsFactory;
import core.utils.DataUtils;
import core.utils.SqlUtils;
import core.utils.fieldMappings.CollectionFieldMapping;
import core.utils.fieldMappings.ReferenceFieldMapping;
import core.utils.fieldMappings.SqlFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.errors.IllegalOperationError;

import namespaces.data_mapping;
import utils.StringUtils;

import metadata.TypeMapping;

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.errors.IllegalStateError;

use namespace data_mapping;
public class QuerySelectionBuilder {
    public static const PROPERTIES_SEPARATOR : String = ".";
    public static const ALIAS_SEPARATOR : String = "__";
    public static const PROPERTY_ALIAS_PLACEHOLDER_IN_SELECTION : String = "#";
    public static const ARG_PLACEHOLDER_IN_SELECTION : String = "?";
    private var typeMappings : TypeMappings;

    /** keys: table to which there's a mapping, values: a collection of fieldMappings which map to keys and their owner tables **/
    private var joinsMap : Object = {};
    private var whereExpressions : Array = [];
    private var whereArguments : Object = {};
    private var selectExpressions : Array = [];
    private var orderByExpressions : Array = [];
    private var whereArgsCount : uint = 0;
    private var limit : int = -1;
    private var start : int = -1;

    data_mapping function setLimit(v : int) : void {
        if (limit >= 0) throw new IllegalOperationError("limit is set twice!");
        limit = v;
    }

    data_mapping function setStart(v : int) : void {
        if (start >= 0) throw new IllegalOperationError("start is set twice!");
        if (limit == -1) throw new IllegalStateError("set limit before setting start!");
        start = v;
    }


    data_mapping function getRawResults(sqlConnection : SQLConnection, clazz : Class, alias : String = null) : Array {
        if (!alias) {
            alias = getDetaultRootAlias(getMapping(clazz));
        }
        var mapping:TypeMapping = getMapping(clazz);
        addSelectFrom(mapping.table, alias);

        var statement : SQLStatement = SqlStatementsFactory.create(buildSql(clazz, alias));
        addArguments(statement);
        var result : Array = SqlUtils.executeWithResult(statement, sqlConnection);
        return result;
    }

    data_mapping function addSelection(selection : String, propertyChains : Array, args : Array) : void {
        var propertyChainAliases : Array = [];
        for each (var propertyChain : PropertyChain in propertyChains) {
            propertyChainAliases.push(addProperty(propertyChain))
        }
        addWhere(selection, propertyChainAliases, args);
    }

    private function getRootAlias(propertyChain:PropertyChain):String {
        var propertiesRootAlias:String = propertyChain.rootAlias;
        if (propertiesRootAlias == null) {
            var typeMapping:TypeMapping = getMapping(propertyChain.rootClass);
            propertiesRootAlias = getDetaultRootAlias(typeMapping);
        }
        return propertiesRootAlias;
    }


    data_mapping function orderBy(propertyChain : PropertyChain, orderByAsc : Boolean) : void {
        orderByProperty(addProperty(propertyChain), orderByAsc);
    }

    /**
     *
     * @param orderByAlias sql path to property by which we need to order
     * @param orderByAsc
     */
    private function orderByProperty(orderByAlias : String, orderByAsc : Boolean) : void {
        if (StringUtils.isEmpty(orderByAlias)) {
            return;
        }
        orderByExpressions.push(orderByAlias + (orderByAsc ? " ASC" : " DESC"));
    }

    private function buildSql(clazz : Class, alias : String):String {

        var sql:String = "SELECT DISTINCT " + getSelectColumns(alias).join(", ")
                + getFromSql()
                + getJoins()
                + getWhereSql()
                + getOrderBySql()
                + getLimitSql() + ";";
        return sql;
    }

    private function getFromSql():String {
        return " FROM " + selectExpressions.join(", ");
    }

    private function getLimitSql():String {
        if (limit > 0 && start >= 0) {
            return " LIMIT " + limit + "," + start;
        }
        else if (limit > 0) {
            return " LIMIT " + limit;
        }
        return "";
    }

    private function getOrderBySql():String {
        return (orderByExpressions.length > 0 ? " ORDER BY " + orderByExpressions.join(", ") : "");
    }

    private function getWhereSql():String {
        if (whereExpressions.length == 0) return "";
        return " WHERE (" + whereExpressions.join(") AND (") + ")";
    }

    private static function getSelectColumns(alias:String):Array {
        return [alias + ".*"];
    }

    private function addArguments(result:SQLStatement):void {
        for (var argName:String in whereArguments) {
            result.parameters[argName] = whereArguments[argName];
        }
    }

    /**
     *  registers for joins
     * @param propertyChain reference properties for {#link rootClass}. The last property can be primitive.
     * Not collections are supported at the moment
     * @return sql path to the property
     */
    private function addProperty(propertyChain : PropertyChain) : String
    {
        var rootTypeMapping:TypeMapping = getMapping(propertyChain.rootClass);
        var rootAlias : String = getRootAlias(propertyChain);
        addSelectFrom(rootTypeMapping.table, rootAlias);
        if (propertyChain.chain == null) {
            return rootAlias + "." + Constants.ID_COLUMN_NAME;
        }
        var fieldNames : Array  = propertyChain.chain.split(PROPERTIES_SEPARATOR);
        var parentClass : Class = propertyChain.rootClass;
        var parentTableAlias : String = rootAlias;//ALIAS_SEPARATOR + typeMapping.table;
        var fieldMapping : SqlFieldMapping;
        for each (var fieldName : String in fieldNames) {
            fieldMapping = getFieldMapping(parentClass, fieldName);
            if (fieldMapping == null) {
                throw new IllegalArgumentError(parentClass + " does not have field named \"" + fieldName + "\" with [Column] metadata");
            }
            var fieldAlias : String = parentTableAlias + ALIAS_SEPARATOR + fieldMapping.fieldName;
            if (fieldMapping is ReferenceFieldMapping) {
                var fieldClass : Class = DataUtils.getClass(fieldMapping.typeName);
                var fieldTypeMapping:TypeMapping = getMapping(fieldClass);
                joinOnField(parentTableAlias, fieldMapping.columnName, fieldTypeMapping.table, fieldAlias, Constants.ID_COLUMN_NAME);
                parentClass = fieldClass;
            } else if (fieldMapping is CollectionFieldMapping) {
                var collectionAlias:String = fieldAlias + "_C";
                joinOnField(parentTableAlias, fieldMapping.columnName, Constants.COLLECTIONS_TABLE, collectionAlias, Constants.COLLECTION_ID_COLUMN_NAME);
                var itemClass:Class = DataUtils.getClass(CollectionFieldMapping(fieldMapping).collectionItemType);
                var itemsTable : String = getMapping(itemClass).table;
                joinOnField(collectionAlias, Constants.ID_COLUMN_NAME, itemsTable, fieldAlias, Constants.ID_COLUMN_NAME)
                parentClass = itemClass;
            } else {
                break;
            }
            parentTableAlias = fieldAlias;
        }
        var lastColumnName : String = (fieldMapping is ReferenceFieldMapping || fieldMapping is CollectionFieldMapping) ? Constants.ID_COLUMN_NAME : fieldMapping.columnName;
        return parentTableAlias + "." + lastColumnName;
    }

    private function addSelectFrom(table : String, alias : String):void {
        var selectFrom : String = table + " AS " + alias;
        if (selectExpressions.indexOf(selectFrom) == -1) {
            selectExpressions.push(selectFrom);
        }
    }

    /**
     *
     * @param selection a string which contains # symbol which needs to be replaced with propertyAliases,
     * and ? symbol which needs to be replaced with args.
     * @param propertyChainAliases expressions representing chains.
     * @param args arguments to {#link selection}
     */
    private function addWhere(selection : String, propertyChainAliases : Array, args : Array) : void {
        if (args == null) args = [];
        if (propertyChainAliases == null) propertyChainAliases = [];
        for each (var propertyChainAlias : String in propertyChainAliases) {
            selection = selection.replace(PROPERTY_ALIAS_PLACEHOLDER_IN_SELECTION, propertyChainAlias);
        }
        if (selection.indexOf(PROPERTY_ALIAS_PLACEHOLDER_IN_SELECTION) != -1) {
            throw new IllegalArgumentError("selection " + selection + " contains more placeholder for property chains (" + PROPERTY_ALIAS_PLACEHOLDER_IN_SELECTION+") then chains specified (" + propertyChainAliases.length + ")")
        }
        //add args
        for each (var arg : * in args) {
            var argName:String = nextArgName();
            whereArguments[argName] = arg;
            selection = selection.replace(ARG_PLACEHOLDER_IN_SELECTION, argName);
        }
        if (selection.indexOf(ARG_PLACEHOLDER_IN_SELECTION) != -1) {
            throw new IllegalArgumentError("selection " + selection + " contains more placeholder for arguments (" + ARG_PLACEHOLDER_IN_SELECTION+") then arguments specified (" + args.length + ")")
        }
        whereExpressions.push(selection);
    }

    private function getJoins() : String {
        var result : String = "";
        for (var referencedAlias : String in joinsMap) {
            var reference : ReferenceInfo = joinsMap[referencedAlias];
            result += " INNER JOIN " + reference.referencedTable
                    + " AS " + reference.referencedAlias
                    + " ON " + reference.referencingAlias + "." + reference.referencingColumn
                    + "=" + reference.referencedAlias + "." + reference.referencedTableKey;
        }
        return result;
    }

    /**
     * check {#link getJoins}
     * @param referencingColumn
     * @param referencingAlias
     * @return returns Table in which field is stored
     */
    private function joinOnField(referencingAlias:String, referencingColumn:String, referencedTable : String, referencedAlias:String, referencedTableKey : String):void {
        if (joinsMap[referencedAlias] != null) return;
            joinsMap[referencedAlias] = new ReferenceInfo(referencedTable, referencedAlias, referencedTableKey, referencingColumn, referencingAlias);
    }

    private static function getDetaultRootAlias(typeMapping:TypeMapping):String {
        return ALIAS_SEPARATOR + typeMapping.table;
    }

    private function nextArgName() : String {
        return ":arg" + (whereArgsCount++);
    }

    protected function getMapping(clazz:Class):TypeMapping {
        return typeMappings.getMapping(clazz);
    }

    protected function getFieldMapping(clazz : Class, fieldName : String) : SqlFieldMapping {
        return typeMappings.getFieldMapping(clazz, fieldName);
    }

    public function QuerySelectionBuilder(typeMappings:TypeMappings) {
        this.typeMappings = typeMappings;
    }
}
}

class ReferenceInfo
{
    internal var referencedTable : String;
    internal var referencedTableKey : String;
    internal var referencedAlias : String;
    internal var referencingColumn : String;
    internal var referencingAlias : String;

    public function ReferenceInfo(referencedTable:String, referencedAlias:String, referencedTableKey : String, referencingColumn:String, referencingAlias:String) {
        this.referencedTable = referencedTable;
        this.referencedTableKey = referencedTableKey;
        this.referencedAlias = referencedAlias;
        this.referencingColumn = referencingColumn;
        this.referencingAlias = referencingAlias;
    }
}
