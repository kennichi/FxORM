package core.utils.typeMappings {
import core.utils.fieldMappings.SqlFieldMapping;

import flash.data.SQLConnection;

import metadata.TypeMapping;

public class TypeMappings {
    private var _typeMappingFactory : TypeMappingFactory;
    private var _typeMappingsByClass : Object;
    /**
     * map class to boolean. Defines which types are up-to-date (with DB updated for them).
     */
    private var _validTypes : Object;
    private var _sqlConnection : SQLConnection;

    public function TypeMappings(sqlConnection:SQLConnection) {
        reset(sqlConnection);
    }

    public function getMapping(clazz : Class) : TypeMapping {
        if (_typeMappingsByClass[clazz] == null) loadMetadata(clazz);
        var result : TypeMapping = _typeMappingsByClass[clazz];
        if (_validTypes[clazz] == null) {
            result.updateTable(_sqlConnection);
            _validTypes[clazz] = true;
        }
        return _typeMappingsByClass[clazz];
    }

    public function getFieldMapping(clazz : Class, fieldName : String) : SqlFieldMapping {
        var mapping:TypeMapping = getMapping(clazz);
        return mapping == null ? null : mapping.getFieldMapping(fieldName);
    }

    public function loadMetadata(clazz : Class) : void {
        var typeMapping : TypeMapping = _typeMappingFactory.create(clazz,  _sqlConnection);
        _typeMappingsByClass[clazz] = typeMapping;
    }

    private function reset(sqlConnection:SQLConnection):void {
        _sqlConnection = sqlConnection;
        _typeMappingFactory = new TypeMappingFactory()
        _validTypes = {};
        _typeMappingsByClass = {};
    }
}
}
