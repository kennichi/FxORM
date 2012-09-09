package profiling {
/**
 * Implement this interface to enable profiling of FxORM events.
 */
public interface IFxORMProfiler {
    /**
     * called when DB query is executed.
     * @param queryText text of the query
     * @param parameters dictionary with parameters to the query
     * @param dataBaseTime the time it took for the database to execute the query
     * @param rowCount number of rows affected
     */
    function onQuery(queryText:String, parameters:Object, dataBaseTime:Number, rowCount:int) : void;

    /**
     * called when an error is caught
     * @param error error message
     */
    function onError(error : String) : void;

    /**
     * called when begin transaction is called
     */
    function onBeginTransaction() : void;
    /**
     * called when commit transaction is called
     */
    function onCommitTransaction() : void;
    /**
     * called when rollback transaction is called
     */
    function onRollbackTransaction() : void;

    /**
     * called when a PersistentObject is cached
     * @param obj
     */
    function onObjectPutToCache(obj:IPersistentObject) : void;

    /**
     * called when PersistentObject is removed from cache
     * @param obj
     */
    function onObjectRemovedFromCache(obj:IPersistentObject) : void;

    /**
     * called when PersistentObject is retrieved from cache
     * @param obj
     */
    function onObjectRetrievedFromCache(obj:IPersistentObject) : void;

    /**
     * called when an Entity Operation is about to executed. Entity Operations are basic operations executed by FxORM. For example, getting object by its id. Check core.entityOperations package for more details.
     * @param operationClass the class of the operation.
     * @param arguments arguments to execute method of operation.
     */
    function onOperationStart(operationClass:Class, arguments:Array):void;

    /**
     * called when an Entity Operation finishes executing.
     * @param operationClass the class of the operation.
     * @param arguments arguments to execute method of operation.
     * @param result result returned by the operation
     * @param milliseconds time it took to execute the operation
     */
    function onOperationFinish(operationClass:Class, arguments:Array, result:*, milliseconds:Number):void;
}
}
