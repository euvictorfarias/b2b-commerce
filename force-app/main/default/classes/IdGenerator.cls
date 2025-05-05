/**
 * @author: Carlos Farias - GFT
 */

@isTest 
public class IdGenerator {
    
    private static Integer sequence = 0; 

    private static final Integer PREFIX_LENGHT = 3;
    private static final Integer ORG_INSTANCE_RESERVED_LENGHT = 5;
    private static final String BASE62_ALPHABET = '0123456789abcdefghijklmnopqrstuvwqyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

    public static List<SObject> generateByRecords(List<SObject> records) {

        for(SObject record : records ) {
            generateByRecord(record);            
        }

        return records;

    }

    public static SObject generateByRecord(SObject record) {

        record.Id = IdGenerator.generateByObjectType(record.getSObjectType());

        return record;

    }

    public static String generateByObjectType(Schema.SObjectType type) {
        return generateByObjectPrefix(type.getDescribe().getKeyPrefix());
    }
    
    public static String generateByObjectPrefix(String objectPrefix) {

        String prefix = objectPrefix + UserInfo.getUserId().substring(PREFIX_LENGHT, ORG_INSTANCE_RESERVED_LENGHT) + '00000';
        String id = prefix + buildRandom() + (++sequence);

        return appendSufix(id);

    }

    private static String buildRandom() {

        String randomSequence = '';

        for(Integer i = 0; i < 4; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), BASE62_ALPHABET.length());
            randomSequence += BASE62_ALPHABET.substring(idx, idx+1);
        }

        return randomSequence;

    }

    private static String appendSufix(String id) {

        String suffix = '';
        String baseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345';

        for(Integer i = 0; i < 3; i++) {

            Integer flags = 0;

            for(Integer j = 0; j < 5; j++) {

                String c = id.substring( i * 5 + j , i * 5 + j + 1);

                if((c.compareTo('A')>=0) && (c.compareTo('Z')<=0)){
                    flags += 1 << j;
                }

            }

            suffix += baseChars.substring(flags, flags+1);
        }

        return id + suffix;

    }

}