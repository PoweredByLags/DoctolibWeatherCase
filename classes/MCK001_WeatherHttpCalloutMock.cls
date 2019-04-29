/**
* @author Majid MAÏSSA
* @date 28/04/2019
* @description Mock Class for Weather HTTP Callouts
*/
@isTest
global class MCK001_WeatherHttpCalloutMock implements HttpCalloutMock {
	
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"weatherObservation":{"elevation":8,"lng":-1.8,"observation":"LESO 161400Z 03010KT 350V060 9999 FEW040 16/11 Q1018","ICAO":"LESO","clouds":"quelques nuages","dewPoint":"11","cloudsCode":"FEW","datetime":"2019-04-16 14:00:00","countryCode":"ES","temperature":"16","humidity":72,"stationName":"San Sebastian / Fuenterrabia","weatherCondition":"n/a","windDirection":30,"hectoPascAltimeter":1018,"windSpeed":"10","lat":43.35}}');
        res.setStatusCode(200);
        return res;
    }
}