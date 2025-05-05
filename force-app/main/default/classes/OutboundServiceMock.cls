/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called when mocked Outbound calls are nedded 
 * 
 */

@isTest
public class OutboundServiceMock extends OutboundService implements HttpCalloutMock {

    private Http http;
    private HttpRequest request;
    public HttpResponse response;

    public String staticBody = '{"default":"response"}';
    public Integer staticStatusCode = 200;

    public OutboundServiceMock() {
        this.http = new Http();
        this.request = new HttpRequest();
        this.response = new HttpResponse();
    }
	
    override
    public OutboundService withEndpoint(String endpoint) {
        this.request.setEndpoint(endpoint);
        return this;
    }
	
    override
    public OutboundService withMethod(String method) {
        this.request.setMethod(method);
        return this;
    }
	
    override
    public HttpResponse send() {
        return respond(this.request);
    }
    
    public HttpResponse respond(HTTPRequest request) {
        
        this.response.setHeader('Content-Type', 'application/json');
        this.response.setBody(staticBody);
        this.response.setStatusCode(staticStatusCode);

        return this.response;
        
    }

}
