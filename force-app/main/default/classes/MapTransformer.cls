/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * Utility class created to transform Map collections.
 */

public class MapTransformer {
    
    public static Map<Object, SObject> indexListByField(List<SObject> records, String field) {
                                                                     
        if(ListValidator.isEmptyOrNull(records)) {
            return new Map<Object, SObject>();
        }

        Map<Object, SObject> values = new Map<Object, SObject>();
        
        for(SObject record : records) {
        
            Object value = (Object) record.get(field);
            
            if(value == null) continue;
            
            values.put(value, record);

        }
        
        return values;

    }
    
    public static Map<Object, List<SObject>> groupListByField(List<SObject> records, String field) {
                                                                
        if(ListValidator.isEmptyOrNull(records)) {
            return new Map<Object, List<SObject>>();
        }

        Map<Object, List<SObject>> recordsToReturn = new Map<Object, List<SObject>>();                                                     

        for(SObject record : records) {
        
            Object value = (Object) record.get(field);
            
            if(value == null) continue;
            
            if(recordsToReturn.get(value) == null) {
                recordsToReturn.put(value, new List<SObject>());
            }
            
            recordsToReturn.get(value).add(record);

        }
        
        return recordsToReturn;

    }

}