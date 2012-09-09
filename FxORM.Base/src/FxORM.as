package {
import interfaces.IEntityManager;

import profiling.FxORMProfiler;

import profiling.IFxORMProfiler;

public class FxORM {
    private static var _instance : FxORM;
    public static function get instance() : FxORM
    {
        if (!_instance) _instance = new FxORM();
        return _instance;
    }
    private var _entityManager : IEntityManager;
    private var _profiler : IFxORMProfiler = new FxORMProfiler();

    public function get entityManager():IEntityManager {
        if (!_entityManager) _entityManager = new DummyEntityManger();
        return _entityManager;
    }

    public function set entityManager(value:IEntityManager):void {
        _entityManager = value;
    }

    public function get profiler():IFxORMProfiler {
        return _profiler;
    }

    public function set profiler(value:IFxORMProfiler):void {
        _profiler = value;
    }
}
}
