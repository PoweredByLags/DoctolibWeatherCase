/**
* @author Majid MAÏSSA
* @date 28/04/2019
* @description Utility Class 001 Test Class
*/

@isTest
public class UTILS001_Utilities_TEST {
    
    @isTest
    public static void convertWindSpeedTest() {
        Test.startTest();
        
        Decimal originalSpeed = 6.43;
        
        Decimal speedKTToKMH = UTILS001_Utilities.convertWindSpeed('KT', originalSpeed);
        Decimal speedMPSToKMH = UTILS001_Utilities.convertWindSpeed('MPS', originalSpeed);
        Decimal speedKMHToKMH = UTILS001_Utilities.convertWindSpeed('KMH', originalSpeed);
        Decimal error = UTILS001_Utilities.convertWindSpeed('KMH', null);
        
        Test.stopTest();
        
        System.assertEquals(originalSpeed,speedKMHToKMH);
        System.assertEquals(((originalSpeed*60*60)/1000),speedMPSToKMH);
        System.assertEquals((originalSpeed*1.852).round(System.RoundingMode.UP),speedKTToKMH);
        System.assertEquals(null, error);
        
    }
    
    @isTest
    public static void metarCodeDecodingTest() {
        
        Test.startTest();
        
        String METARThunderStorm = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000TS FEW RA');
        String METARCloudySun = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000FEW');
        String METARSunny = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000SKC');
        String METARRainy = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000SH RA');
        String METARSnowy = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000SN GS');
        String METARSunShower = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000SH RA FEW');
        String METARCloudy = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000BKN OVC');
        String METARDefault = UTILS001_Utilities.metarCodeDecoding('LFQN 201630Z 18005KT 4000NO VALUE');
        
        String error = UTILS001_Utilities.metarCodeDecoding(null);
        
        Test.stopTest();
        
        System.assertEquals('thunder-storm',METARThunderStorm);
        System.assertEquals('cloudy-sun',METARCloudySun);
        System.assertEquals('sunny',METARSunny);
        System.assertEquals('rainy',METARRainy);
        System.assertEquals('snowy',METARSnowy);
        System.assertEquals('sun-shower',METARSunShower);
        System.assertEquals('cloudy',METARCloudy);
        System.assertEquals('cloudy-sun',METARDefault);
        System.assertEquals(null,error);
    }
    
    @isTest
    public static void sendWeatherReportTest() {
        Integer beforeInvocations = Limits.getEmailInvocations();
      	System.assertEquals(0,beforeInvocations);
        
        Test.startTest();
        List<String> recipients = new List<String>{'apextest@mail-com.com', 'apextest2@mail-com.com'};
        UTILS001_Utilities.sendWeatherReport(recipients, '10', 20, 3, 'clouds', 'weatherState');
        UTILS001_Utilities.sendWeatherReport(null, '10', 20, 3, 'clouds', 'weatherState');
        Integer afterInvocations = Limits.getEmailInvocations();
        Test.stopTest();

      	System.assertEquals(1,afterInvocations);
    }

}