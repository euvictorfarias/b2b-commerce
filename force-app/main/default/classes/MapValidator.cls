/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * @description: Utility class created to validate Map collections.
 */

 public class MapValidator {
    
    public static Boolean isEmptyOrNull(Map<Object, Object> records) {
        return records == null || records.isEmpty();
    }

}