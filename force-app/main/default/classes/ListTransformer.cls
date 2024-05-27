/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to transform List collections.
 */

public class ListTransformer {

    public static List<Object> getField(List<SObject> records, String field) {

        if(ListValidator.isEmptyOrNull(records)) {
            return new List<Object>();
        }

        Set<Object> recordsToReturn = new Set<Object>();

        for(SObject record : records) {
            recordsToReturn.add(record.get(field));
        }

        return new List<Object>{recordsToReturn};
        
    }
    
    public static List<SObject> setToList(Set<SObject> records) {

        if(SetValidator.isEmptyOrNull(records)) {
            return new List<SObject>();
        }

        List<SObject> recordsToReturn = new List<SObject>();

        for(SObject record : records) {
            recordsToReturn.add(record);
        }

        return recordsToReturn;

    }

}