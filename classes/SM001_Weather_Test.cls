/**
* @author Majid MAÏSSA
* @date 28/04/2019
* @description Service Manager Class 001 Test Class
*/

@isTest
public class SM001_Weather_Test {
    
    @isTest
    public static void getWeatherTest() {
        Test.setMock(HttpCalloutMock.class, new MCK001_WeatherHttpCalloutMock());
        Test.startTest();
        SM001_Weather.WeatherWrapper wrp = SM001_Weather.getWeather(1, 1);
        Test.stopTest();
        System.assertEquals('16', wrp.temperature);
        System.assertEquals(72, wrp.humidity);
        System.assertEquals('quelques nuages', wrp.clouds);
        System.assertEquals('cloudy-sun', wrp.weatherState);
    }
    
    @isTest
    public static void getAccountGeoLocationTest() {
        Account account = new Account();
        account.Name = 'Test';
        account.BillingLatitude = 43;
        account.BillingLongitude = -2;
        
        Test.startTest();
        insert account;
        Account retrievedAccount = SM001_Weather.getAccountGeoLocation(account.Id);
        Account retrievedAccountError = SM001_Weather.getAccountGeoLocation(null);
        Test.stopTest();
        
        System.assertEquals(43, retrievedAccount.BillingLatitude);
        System.assertEquals(-2, retrievedAccount.BillingLongitude);
        System.assertEquals(null, retrievedAccountError);
    }
    
    @isTest
    public static void sendMailReportTest() {
        Account account = new Account();
        account.Name = 'Test';
        
        Contact contact = new Contact();
        contact.FirstName = 'TestName';
        contact.LastName = 'TestLastName';
        contact.Email = 'testmail@contact-mail.com';
        
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User user = new User(Alias = 'standt', Email='testclassusername@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testclassusername@testorg.com');
        
        Integer beforeInvocations = Limits.getEmailInvocations();
      	System.assertEquals(0,beforeInvocations);
        
        Test.startTest();
        insert account;
        contact.AccountId = account.Id;
        insert contact;
        insert user;
        
        SM001_Weather.sendMailReport('Account', account.Id, '10', 20, 3, 'clouds', 'weatherState');
        SM001_Weather.sendMailReport(null, null, '10', 20, 3, 'clouds', 'weatherState');
        Integer afterInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(2,afterInvocations);
    }
    
    @isTest
    public static void updateLastSentReportDateTest() {
        
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User user = new User(Alias = 'standt', Email='testclassusername@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testclassusername@testorg.com');
        
        Test.startTest();
        insert user;
        System.runAs(user) {
            SM001_Weather.updateLastSentReportDate();
        }
        User user1 = [SELECT Id, Last_Sent_Weather_Report__c FROM User where Id=:user.Id][0];
        Test.stopTest();
        System.assertEquals(Date.today(), user1.Last_Sent_Weather_Report__c);
    }
}