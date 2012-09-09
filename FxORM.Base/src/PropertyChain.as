package {
import namespaces.data_mapping;
use namespace data_mapping;

public class PropertyChain {
    data_mapping var chain : String;
    data_mapping var rootClass : Class;
    data_mapping var rootAlias : String;

    public function PropertyChain(chain:String, rootClass:Class, rootAlias : String = null) {
        this.chain = chain;
        this.rootClass = rootClass;
        this.rootAlias = rootAlias;
    }
}
}
