package interfaces {
import namespaces.data_mapping;

use namespace data_mapping;

public interface ISelectionBuilder {

    /**
     *
     * @param selection a string for WHERE clause. Can contain # and ? characters.
     * # will be substituted by propertyChains from {#link propertyChains}.
     * ? will be substituted by arguments from {#link arguments}.
     * @param propertyChains
     * @param arguments
     * @return {#link ISelectionBuilder}
     */
    function where(selection:String, propertyChains:Array, arguments:Array = null):ISelectionBuilder;

    /**
     * orders by {#link propertyChain}
     * @param propertyChain
     * @param orderByAsc true for ASC order
     * @return {#link ISelectionBuilder}
     */
    function orderBy(propertyChain:*, orderByAsc:Boolean = true):ISelectionBuilder;

    /**
     * @param limit limits the response to the first {#link limit} results.
     * @return Array of PersistentObjects (result for the query).
     */
    function query(limit:int = 0):Array;

    /**
     *
     * @param pageNumber limits the response to return only results for the page defined by {#link pageNumber}, 0-based
     * @param itemsPerPage specifies the number of items in a page
     * @return Array of PersistentObjects (result for the query).
     */
    function queryPage(pageNumber : uint, itemsPerPage : uint):Array;
}
}
