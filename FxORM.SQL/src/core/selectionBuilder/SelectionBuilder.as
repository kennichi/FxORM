package core.selectionBuilder {
import core.entityOperations.EntityOperationsFacade;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import interfaces.ISelectionBuilder;
import PropertyChain;

import namespaces.data_mapping;

import org.spicefactory.lib.errors.IllegalArgumentError;

import org.spicefactory.lib.errors.IllegalStateError;

use namespace data_mapping;
public class SelectionBuilder implements ISelectionBuilder {

    /**
     * type which is queried
     */
    private var _clazz : Class;
    private var _alias : String;
    private var _builder : QuerySelectionBuilder;
    private var _sqlConnection : SQLConnection;
    private var _operations:EntityOperationsFacade;

    /**
     * #data_mapping
     * @param typeMappings
     * @param sqlConnection
     * @param operations
     */
    public function SelectionBuilder(typeMappings:TypeMappings, sqlConnection:SQLConnection, operations:EntityOperationsFacade) {
        _sqlConnection = sqlConnection;
        _operations = operations;
        _builder = new QuerySelectionBuilder(typeMappings);
    }

    data_mapping function on(clazz:Class, alias:String = null):ISelectionBuilder {
        if (_clazz != null) throw new IllegalStateError("Class has already been specified");
        this._clazz = clazz;
        this._alias = alias;
        return this;
    }

    /**
     *
     * @param selection a string for WHERE clause. Can contain # and ? characters.
     * # will be substituted by propertyChains from {#link propertyChains}.
     * ? will be substituted by arguments from {#link arguments}.
     * @param propertyChains
     * @param arguments
     * @return {#link ISelectionBuilder}
     */
    public function where(selection:String, propertyChains:Array, arguments:Array = null):ISelectionBuilder {
        if (arguments == null) arguments = [];
        assertClazz();
        _builder.addSelection(selection, toPropertyChains(propertyChains), arguments);
        return this;
    }

    /**
     * orders by {#link propertyChain}
     * @param propertyChain
     * @param orderByAsc true for ASC order
     * @return {#link ISelectionBuilder}
     */
    public function orderBy(propertyChain:*, orderByAsc:Boolean = true):ISelectionBuilder {
        assertClazz();
        _builder.orderBy(toPropertyChain(propertyChain), orderByAsc);
        return this;
    }

    /**
     *
     * @param pageNumber limits the response to return only results for the page defined by {#link pageNumber}, 0-based
     * @param itemsPerPage specifies the number of items in a page
     * @return Array of PersistentObjects (result for the query).
     */
    public function queryPage(pageNumber : uint, itemsPerPage : uint):Array {
        assertClazz();
        _builder.setLimit(itemsPerPage);
        _builder.setStart(pageNumber*itemsPerPage);
        return execute();
    }

    /**
     * @param limit limits the response to the first {#link limit} results.
     * @return Array of PersistentObjects (result for the query).
     */
    public function query(limit:int = 0):Array {
        assertClazz();
        _builder.setLimit(limit);
        return execute();
    }

    private function execute():Array {
        return convertArray(_builder.getRawResults(_sqlConnection, _clazz, _alias), _clazz);
    }

    private function convertArray(source : Array, c : Class) : Array
    {
        if (source == null) return [];
        var result : Array = new Array();
        for each (var o : Object in source) {
            result.push(_operations.convertObject(o, c));
        }
        return result;
    }

    private function toPropertyChains(propertyChains : Array) : Array {
        var result : Array = new Array();
        for each (var chainValue : * in propertyChains) {
            result.push(toPropertyChain(chainValue));
        }
        return result;
    }

    private function toPropertyChain(chainValue:*) : PropertyChain {
        assertClazz();
        if (chainValue is String) {
            return new PropertyChain(chainValue, _clazz);
        } else if (chainValue is PropertyChain) {
            return chainValue;
        } else {
            throw new IllegalArgumentError("Unsupported type for propertyChain: " + chainValue);
        }
    }

    private function assertClazz() : void {
        if (_clazz == null) {
            throw new IllegalStateError("Class not specified");
        }
    }
}
}
