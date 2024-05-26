/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to transform Set collections.
 */

public class SetTransformer {
    
    public static Set<Object> getField(Set<SObject> records, String field) {

        if(SetValidator.isEmptyOrNull(records)) {
            return new Set<Object>();
        }

        Set<Object> recordsToReturn = new Set<Object>();

        for(SObject record : records) {
            recordsToReturn.add(record.get(field));
        }

        return new Set<Object>{recordsToReturn};
        
    }

    public static Set<SObject> listToSet(List<SObject> records) {

        if(ListValidator.isEmptyOrNull(records)) {
            return new Set<SObject>();
        }

        Set<SObject> recordsToReturn = new Set<SObject>();

        for(SObject record : records) {
            recordsToReturn.add(record);
        }

        return recordsToReturn;

    }

}