/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called when Outbound calls are nedded 
 * 
 */

public class OutboundService {

    private Http http;
    private HttpRequest request;
    public HttpResponse response;

    public OutboundService() {
        this.http = new Http();
        this.request = new HttpRequest();
        this.response = new HttpResponse();
    }

    public OutboundService withEndpoint(String endpoint) {
        this.request.setEndpoint(endpoint);
        return this;
    }

    public OutboundService withMethod(String method) {
        this.request.setMethod(method);
        return this;
    }

    public HttpResponse send() {
        this.response = this.http.send(this.request);
        return this.response;
    }

}
