/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to validate Map collections.
 */

public class MapValidator {
    
    public static Boolean isEmptyOrNull(Map<Object, SObject> records) {
        return records.isEmpty() || records == null;
    }

}