/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for the OutboundService class
 * 
 */

@isTest
public class OutboundServiceTest {

    @isTest
    public static void givenTestedClassWhenSendMethodIsCalledThenMakeCallout() {
        
        Test.setMock(HttpCalloutMock.class, new OutboundServiceMock());

        Test.startTest();

        HttpResponse response = new OutboundService()
            .withEndpoint('https://api.exemplo.com/endpoint')
            .withMethod('GET')
            .send();

        Test.stopTest();

        Assert.isNotNull(response);
        Assert.areEqual(200, response.getStatusCode());
    }

}
