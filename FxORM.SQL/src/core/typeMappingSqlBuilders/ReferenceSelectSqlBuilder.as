package core.typeMappingSqlBuilders {

public class ReferenceSelectSqlBuilder implements IReferenceSqlStatementsBuilder {
    public function build(tableName:String, fieldColumns:Object, dbColumns:Object):Array {
        return ["SELECT * FROM " + tableName];
    }
}
}
