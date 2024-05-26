/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to filter Set collections.
 */

public class SetFilter {
    
    public static Set<SObject> byFieldValue(Set<SObject> records, String field, Object value) {

        if(SetValidator.isEmptyOrNull(records)) {
            return new Set<SObject>();
        }

        Set<SObject> recordsToReturn = new Set<SObject>();

        for(SObject record : records) {
            if(record.get(field) == value) {
                recordsToReturn.add(record);
            }
        }

        return recordsToReturn;
        
    }

    public static Set<SObject> byNullField(Set<SObject> records, String field) {

        if(SetValidator.isEmptyOrNull(records)) {
            return new Set<SObject>();
        }

        Set<SObject> recordsToReturn = new Set<SObject>();

        for(SObject record : records) {
            if(record.get(field) == null) {
                recordsToReturn.add(record);
            }
        }

        return recordsToReturn;
        
    }

    public static Set<SObject> byNotNullField(Set<SObject> records, String field) {

        if(SetValidator.isEmptyOrNull(records)) {
            return new Set<SObject>();
        }

        Set<SObject> recordsToReturn = new Set<SObject>();

        for(SObject record : records) {
            if(record.get(field) != null) {
                recordsToReturn.add(record);
            }
        }

        return recordsToReturn;
        
    }

}