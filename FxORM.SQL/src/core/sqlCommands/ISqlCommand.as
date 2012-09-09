package core.sqlCommands {
import flash.data.SQLConnection;

public interface ISqlCommand {
    function execute(sqlConnection : SQLConnection) : void;
}
}
