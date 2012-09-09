package core {
import flash.data.SQLConnection;
import flash.data.SQLStatement;

public class SqlStatementsFactory {
    private var _sqlConnection : SQLConnection;
    private var _statements : Array = [];
    public function SqlStatementsFactory() {
    }

    public static function create(text : String) : SQLStatement {
        var statement : SQLStatement = new SQLStatement();
        statement.text = text;
        return statement;
    }

    public function create(text : String) : SQLStatement {
        var statement : SQLStatement = SqlStatementsFactory.create(text);
        statement.sqlConnection = _sqlConnection;
        _statements.push(statement);
        return statement;
    }
}
}
