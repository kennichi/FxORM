package core.typeMappingSqlBuilders {

public interface IReferenceSqlStatementsBuilder {
    /**
     *
     * @param tableName
     * @param fieldColumns map where reference's field names are keys, and {#link FieldMapping} objects are values
     * @param dbColumns map where reference's field names are keys, and column names in DB are values
     * @param columnDefinitions array of String DB column definitions in the form "<COLUMN_NAME/> <COLUMN_TYPE/>"
     * @return Array of Strings which represent SQL statements
     */
    function build(tableName : String, fieldColumns : Object, dbColumns : Object) : Array;
}
}
