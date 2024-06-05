/**
 * @author: Carlos Farias 
 * @version: 1.0.1
 * 
 * @description: Abstract class created to allow child classes to execute DML operations.
 */

public abstract class AbstractDmlOperations {

    virtual
    public SObject insertRecord(SObject record) {

        if(record == null) {
            return null;
        }

        insertRecords(new List<SObject>{record});
        return record;

    }

    virtual
    public List<SObject> insertRecords(List<SObject> records) {

        if(records.isEmpty() || records == null) {
            return new List<SObject>();
        }

        insert records;
        return records;

    }

    virtual
    public List<SObject> updateRecords(List<SObject> records) {

        if(records.isEmpty() || records == null) {
            return new List<SObject>();
        }

        update records;
        return records;

    }
    
    virtual
    public List<SObject> upsertRecords(List<SObject> records) {

        if(records.isEmpty() || records == null) {
            return new List<SObject>();
        }

        upsert records;
        return records;

    }

    virtual
    public List<SObject> deleteRecords(List<SObject> records) {

        if(records.isEmpty() || records == null) {
            return new List<SObject>();
        }

        delete records;
        return records;

    }

}
