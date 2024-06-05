/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * @description: Utility class created to validate List collections.
 */

 public class ListValidator {
    
    public static Boolean isEmptyOrNull(List<SObject> records) {
        return records.isEmpty() || records == null;
    }

}