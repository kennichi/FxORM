package utils
{
public class StringUtils {
    public static function isEmpty(value : String) : Boolean {
        return value == null || value.length == 0;
    }

    public static function replace( original:String, replace_with:String, replace_what:String):String {
        var array:Array = original.split(replace_what);
        return array.join(replace_with);
    }
}
}