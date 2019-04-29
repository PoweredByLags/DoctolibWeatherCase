/**
 * @author Majid MAÏSSA
 * @date 28/04/2019
 * @description Datas Manager 001 - Weather management
 */

public with sharing class DM001_Weather {
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method calling the weather webservice with the latitude and longitude of the Account or Current User Location.
     * @param latitude The latitude to call the Webservice with.
     * @param longitude The longitude to call the Webservice with.
     * @return String The JSON response from the Webservice.
     */ 
    public String getWeatherJSONByLatAndLong(Double latitude, Double longitude) {
		Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.Weather_Webservice_Url+'lat='+latitude+'&lng='+longitude+'&username='+Label.Weather_Webservice_Username+'&lang='+UserInfo.getLanguage().substringBefore('_'));
        request.setMethod('GET');
        HttpResponse response = new HttpResponse();
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                return response.getBody();
            } else {
                return 'Error ' + response.getStatusCode();
            }
        } catch(Exception exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
            return exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage();
        }
    }
    
}