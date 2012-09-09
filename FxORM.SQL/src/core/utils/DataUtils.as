package core.utils {
import org.spicefactory.lib.reflect.ClassInfo;

public class DataUtils {
    public static function convertStringToSimpleType(source : String, type : String) : * {
        switch (type)
        {
            case "int":
                return int(source);
            case "uint":
                return uint(source);
        }
        return source;
    }

    public static function getClass(className : String) : Class {
        return ClassInfo.forName(className).getClass();
    }

}
}
