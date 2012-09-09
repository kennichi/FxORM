package utils
{
public class DateUtils {
    public static function fromSQLite(seconds : Number) : Date {
        return seconds > 0 ? new Date(seconds * 1000) : null;
    }
}
}