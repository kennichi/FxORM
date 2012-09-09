package core.typeMappingSqlBuilders {

public class ReferenceDeleteSqlBuilder implements IReferenceSqlStatementsBuilder {
    public function build(tableName:String, fieldColumns:Object, dbColumns:Object):Array {
        return ["DELETE FROM " + tableName];
    }
}
}
