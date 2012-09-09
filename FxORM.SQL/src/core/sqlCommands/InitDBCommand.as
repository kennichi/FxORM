package core.sqlCommands {
import core.Constants;
import core.SqlStatementsFactory;
import core.utils.SqlUtils;

import flash.data.SQLConnection;

public class InitDBCommand implements ISqlCommand
{
    public function execute(sqlConnection:SQLConnection):void {
        SqlUtils.execute(SqlStatementsFactory.create("CREATE TABLE IF NOT EXISTS " + Constants.OBJECTS_TABLE + "(" +Constants.ID_COLUMN_NAME+ " INTEGER PRIMARY KEY AUTOINCREMENT, TypeName TEXT, BEId TEXT)"), sqlConnection);
        SqlUtils.execute(SqlStatementsFactory.create("CREATE TABLE IF NOT EXISTS " + Constants.COLLECTIONS_TABLE + "("+ Constants.ID_COLUMN_NAME+" INTEGER NOT NULL, " + Constants.COLLECTION_ID_COLUMN_NAME + " INTEGER NOT NULL)"), sqlConnection);
        SqlUtils.execute(SqlStatementsFactory.create("CREATE INDEX IF NOT EXISTS collIndex ON " + Constants.COLLECTIONS_TABLE + "(" + Constants.COLLECTION_ID_COLUMN_NAME + ")"), sqlConnection);
        SqlUtils.execute(SqlStatementsFactory.create("CREATE TABLE IF NOT EXISTS " + Constants.OBJECTS_TABLE + "(" +Constants.ID_COLUMN_NAME+ " INTEGER PRIMARY KEY AUTOINCREMENT, TypeName TEXT)"), sqlConnection);
        SqlUtils.execute(SqlStatementsFactory.create("CREATE TABLE IF NOT EXISTS COLLECTIONS(" + Constants.COLLECTION_ID_COLUMN_NAME + " INTEGER PRIMARY KEY AUTOINCREMENT, temp INTEGER)"), sqlConnection);
    }
}
}
