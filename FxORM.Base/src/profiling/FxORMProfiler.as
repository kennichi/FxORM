package profiling {
import mx.collections.ArrayCollection;
import mx.logging.ILogger;
import mx.logging.Log;

public class FxORMProfiler implements IFxORMProfiler{

    private static const log : ILogger = Log.getLogger("FxORM");

    public static var DEBUG : Boolean = false;

    /**
     *
     * @param queryText text of the query executed
     * @param parameters parameters to the query executed
     * @param dataBaseTime time it took to execute query
     * @param rowCount number of rows affected by query
     */
    public function onQuery(queryText:String, parameters:Object, dataBaseTime:Number, rowCount:int) : void {
        if (!DEBUG) return;
        var paramsString:String = dictionaryToString(parameters);
        log.debug(queryText + " with values " + paramsString + "; completed in " + dataBaseTime + "ms. ");
    }

    public function onError(error:String) : void {
        log.error(error);
    }

    public function onBeginTransaction() : void {
        if (!DEBUG) return;
        log.debug("Begin Transaction");
    }

    public function onCommitTransaction() : void {
        if (!DEBUG) return;
        log.debug("Commit Transaction");
    }

    public function onRollbackTransaction() : void {
        if (!DEBUG) return;
        log.debug("Rollback Transaction");
    }

    public function onObjectPutToCache(obj:IPersistentObject) : void {
        if (!DEBUG) return;
        log.debug("Object " + obj + " with id " + obj.objectId + " added to cache")
    }

    public function onObjectRemovedFromCache(obj:IPersistentObject) : void {
        if (!DEBUG) return;
        log.debug("Object " + obj + " with id " + obj.objectId + " removed from cache")
    }

    public function onObjectRetrievedFromCache(obj:IPersistentObject) : void {
        if (!DEBUG) return;
        log.debug("Object " + obj + " with id " + obj.objectId + " retrieved from cache")
    }

    public function onOperationStart(operationClass:Class, arguments : Array):void {
        if (!DEBUG) return;
        log.debug("OPERATION " + operationClass + " with arguments: " + objToString(arguments) + " started");
    }

    public function onOperationFinish(operationClass:Class, arguments:Array, result:*, milliseconds:Number):void {
        if (!DEBUG) return;
        log.debug("OPERATION " + operationClass  + " with arguments: " + objToString(arguments) + " completed with result " + objToString(result) + " in " + milliseconds + "ms.");
    }

    private static function objToString(obj : *) : String {
        if (obj == null) return "null";
        if (obj is Array || obj is ArrayCollection) {
            var result : String = "[";
            for each (var item : * in obj) {
                result += objToString(item) + ","
            }
            if (result.length > 1) result = result.substring(0, result.length - 1);
            result += "]"
            return result;
        }
        if (obj.constructor == Object) {
            return dictionaryToString(obj);
        }
        return String(obj);
    }

    private static function dictionaryToString(dictionary:Object):String {
        var paramsString:String = "{";
        for (var key:String in dictionary) {
            paramsString += key + "-> \"" + dictionary[key] + "\",";
        }
        if (paramsString.length > 1) paramsString = paramsString.substring(0, paramsString.length - 1);
        paramsString += "}";
        return paramsString;
    }
}
}
