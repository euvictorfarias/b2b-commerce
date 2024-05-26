/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to filter List collections.
 */

public class ListFilter {
    
    public static List<SObject> byFieldValue(List<SObject> records, String field, Object value) {

        if(ListValidator.isEmptyOrNull(records)) {
            return new List<SObject>();
        }

        List<SObject> recordsToReturn = new List<SObject>();

        for(SObject record : records) {
            if(record.get(field) == value) {
                recordsToReturn.add(record);
            }
        }

        return recordsToReturn;
        
    }

    public static List<SObject> byNullField(List<SObject> records, String field) {

        if(ListValidator.isEmptyOrNull(records)) {
            return new List<SObject>();
        }

        List<SObject> recordsToReturn = new List<SObject>();

        for(SObject record : records) {
            if(record.get(field) == null) {
                recordsToReturn.add(record);
            }
        }

        return recordsToReturn;
        
    }

    public static List<SObject> byNotNullField(List<SObject> records, String field) {

        if(ListValidator.isEmptyOrNull(records)) {
            return new List<SObject>();
        }

        List<SObject> recordsToReturn = new List<SObject>();

        for(SObject record : records) {
            if(record.get(field) != null) {
                recordsToReturn.add(record);
            }
        }

        return recordsToReturn;
        
    }

}