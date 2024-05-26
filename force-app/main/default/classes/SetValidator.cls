/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to validate Set collections.
 */

public class SetValidator {
    
    public static Boolean isEmptyOrNull(Set<SObject> records) {
        return records.isEmpty() || records == null;
    }

}