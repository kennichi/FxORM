package {
import contexts.ReferenceContext;

import flash.events.IEventDispatcher;

/**
 * @see PersistentObject for default implementation
 */
public interface IPersistentObject extends IEventDispatcher {
    [Transient] [Id]
    function get objectId() : uint;
    function set objectId(v : uint) : void;
    function save() : uint;
    function remove() : void;

    /**
     * #private
     */
    function getContext():ReferenceContext;
}
}
