package tests
{

import cache.CacheManager;


import core.EntityManager;

import flash.data.SQLConnection;
import flash.filesystem.File;

import mx.logging.Log;

import mx.logging.Log;

import mx.logging.LogEventLevel;

import mx.logging.targets.TraceTarget;

import org.osmf.logging.Log;

import profiling.FxORMProfiler;

public class BaseTest
{
    protected var _sqlConnection : SQLConnection;
    protected var entityManager : EntityManager;
    private var traceTarget : TraceTarget = new TraceTarget();
    [Before(order=0)]
    public function baseSetUp() : void {
        setUpLogging();
        setUpConnection();
    }

    [After]
    public function closeConnection() : void {
        _sqlConnection.close();
        entityManager = null;
        _sqlConnection = null;
        tearDownLogging();
    }

    public function setUpLogging() : void {
//        FxORMProfiler.DEBUG = true
        traceTarget.level = LogEventLevel.ALL;
        mx.logging.Log.addTarget(traceTarget);
    }

    public function tearDownLogging() : void {
        mx.logging.Log.removeTarget(traceTarget);
    }

    protected function setUpConnection() : void {
        var entityManager : EntityManager = new EntityManager();
        var dbFile : File = File.applicationStorageDirectory.resolvePath( "dm_tests.db" );
        trace( dbFile.nativePath );
        if (dbFile.exists) {
            dbFile.deleteFile();
        }
        _sqlConnection = new SQLConnection();
        _sqlConnection.open( dbFile );
        entityManager.sqlConnection = _sqlConnection;

        this.entityManager = entityManager;
        FxORM.instance.entityManager = entityManager;
    }

    protected function cleanCache() : void {
        CacheManager.instance.reset();
    }

    protected function saveAll(... persistentObjects) : void {
        for each (var persistentObject : IPersistentObject in persistentObjects) {
            persistentObject.save();
        }
    }
}
}