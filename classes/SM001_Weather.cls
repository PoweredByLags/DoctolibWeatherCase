/**
 * @author Majid MAÏSSA
 * @date 28/04/2019
 * @description Service Manager 001 - Weather management
 */

public with sharing class SM001_Weather {
    
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Weather Object Wrapper used to store the data returned by the Webservice.
     */
    public class WeatherWrapper {
        @AuraEnabled public String temperature {get;set;}
        @AuraEnabled public Integer humidity {get;set;}
        @AuraEnabled public Decimal windSpeed {get;set;}
        @AuraEnabled public String weatherState {get;set;}
        @AuraEnabled public String clouds {get;set;}
    }
    
     /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method calling the weather webservice with the latitude and longitude of the Account or Current User Location and transcoding weather codes.
     * @param latitude The latitude to call the Webservice with.
     * @param longitude The longitude to call the Webservice with.
     * @return WeatherWrapper The Weather object containing the response from the Webservice.
     */ 
    @AuraEnabled
    public static WeatherWrapper getWeather(Double latitude, Double longitude) {
        Map<String, Object> responseBody = new Map<String, Object>();
        if(latitude != null && longitude!= null) {
            responseBody = (Map<String, Object>)JSON.deserializeUntyped(EM001_Weather.dataManager.getWeatherJSONByLatAndLong(latitude, longitude));
        }
        //TODO verifier si weatherObservation ou status
		Object responseObject = responseBody.get('weatherObservation');
        Map<String,Object> weatherMap = (Map<String, Object>) responseObject;
        
        WeatherWrapper weather = new WeatherWrapper();
            
        weather.temperature = String.valueOf(weatherMap.get('temperature'));
        weather.humidity = Integer.valueOf(weatherMap.get('humidity'));
        weather.clouds = String.valueOf(weatherMap.get('clouds'));
        
        String observations = String.valueOf(weatherMap.get('observation'));
        
        //Converting wind speed
        weather.windSpeed = UTILS001_Utilities.convertWindSpeed(observations, Decimal.valueOf(String.valueOf(weatherMap.get('windSpeed'))));
        
        //Setting weather State
		weather.weatherState = UTILS001_Utilities.metarCodeDecoding(observations);
        
        return weather;
    }

    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method retrieving the Account geolocation by it's Id.
     * @param Id The Id of the Account to retrieve.
     * @return Account The Account object with it's geolocation data.
     */
    @AuraEnabled
    public static Account getAccountGeoLocation(String Id) {
        if(Id != null && !Id.equals('')) {
			return EM002_Account.dataManager.getAccountById(Id); 
        } else {
            return null;
        }
    }
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method used to send a weather email report to the org Users or the related Contacts of an Account.
     * @param objectName The name of the Object (Account if we are on an Account page else Empty).
     * @param accountId The Id of the Account (if we are on an Account page).
     * @param temperature The temperature to send in the report.
     * @param humidity The humidity to send in the report.
     * @param windSpeed The windSpeed to send in the report.
     * @param clouds The clouds message to send in the report.
     * @param weatherState The weatherState to send in the report.
     */
    @AuraEnabled
    public static void sendMailReport(String objectName, String accountId, String temperature, Integer humidity, Decimal windSpeed, String clouds, String weatherState) {
        List<String> recipients = new List<String>();
        if(objectName == 'Account') {
            for(Contact c: EM004_Contact.dataManager.getContactsEmailByAccountId(accountId)) {
                recipients.add(c.Email);
            } 
        } else {
            for(User u: EM003_User.dataManager.getOrgUsersEmail()) {
                recipients.add(u.Email);
            }
        }
        UTILS001_Utilities.sendWeatherReport(recipients, temperature, humidity, windSpeed, clouds, weatherState);
    }
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method called to update the Last Sent Report field of the User.
     */
    @AuraEnabled
    public static void updateLastSentReportDate() {
        EM003_User.dataManager.updateUserLastSentReportDate();
    }

}