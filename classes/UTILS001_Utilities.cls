/**
* @author Majid MAÏSSA
* @date 28/04/2019
* @description Utility Class 001 - Utility Methods
*/

public with sharing class UTILS001_Utilities {
    
   /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method used to send a weather email report.
     * @param recipients The list of the recipients of the email.
     * @param temperature The temperature to send in the report.
     * @param humidity The humidity to send in the report.
     * @param windSpeed The windSpeed to send in the report.
     * @param clouds The clouds message to send in the report.
     * @param weatherState The weatherState to send in the report.
     */
    public static void sendWeatherReport(List<String> recipients, String temperature, Integer humidity, Decimal windSpeed, String clouds, String weatherState) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(recipients);
        mail.setReplyTo('do-not-reply@doctolib-weather-agent.com');
        mail.setSenderDisplayName('Doctolib Weather Report');
        mail.setSubject('TODAY\'S WEATHER REPORT');
        String body = 'Hello, today it will be ' + weatherState +' with a temperature of ' + temperature + '°C. ';
        body += 'Clouds situation is ' + clouds + '. ';
        body += 'We will have ' + humidity + '% of humidity with a wind of ' +windSpeed+ 'km/h. ';  
        body += 'This is an automated message, please do not reply.';
        mail.setHtmlBody(body);
        
        mails.add(mail);
        
        try {
            Messaging.sendEmail(mails);
        } catch(System.EmailException exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
        }   
    }
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method converting wind speed into km/h.
     * @param unit The unit in which the speed is.
     * @param speed The wind speed.
     * @return Decimal The km/h converted wind speed.
     */ 
    public static Decimal convertWindSpeed(String unit, Decimal speed) {
        if(!unit.equals(' ') && unit != null & speed != null) {
            if(unit.contains('KT')) {
                speed = speed*1.852;
                return speed.round(System.RoundingMode.UP);
            } else if(unit.contains('MPS')) {
                return (speed*60*60)/1000;
            } else {           
                return speed;
            }
        } else {
            return null;
        }
    }
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method decoding the METAR code.
     * @param metarCode The METAR code to decode.
     * @return String The decoded weather situation.
     */ 
    public static String metarCodeDecoding(String metarCode) {
        if(metarCode != null && !metarCode.equals(' ')) {
            if(metarCode.contains('TS')) {
                return 'thunder-storm';
            } else if(metarCode.contains('FEW') && !metarCode.contains('RA')) {
                return 'cloudy-sun';
            }
            else if((metarCode.contains('SKC') || metarCode.contains('NSC')) && !metarCode.contains('RA')) {
                return 'sunny';
            }
            else if (((metarCode.contains('SH') && metarCode.contains('RA')) && (metarCode.contains('FEW') || metarCode.contains('SCT') || metarCode.contains('BKN'))) || (metarCode.contains('RA') && (metarCode.contains('FEW') || metarCode.contains('SCT') || metarCode.contains('BKN')))) {
                return 'sun-shower';
            }
            else if((metarCode.contains('SH') && metarCode.contains('RA')) || metarCode.contains('RA')) {
                return 'rainy';
            }
            else if(metarCode.contains('SN') || metarCode.contains('GS') || metarCode.contains('SG') || metarCode.contains('IC')) {
                return 'snowy';
            }
            else if((metarCode.contains('SCT') || metarCode.contains('BKN') || metarCode.contains('OVC')) && !metarCode.contains('RA')) {
                return 'cloudy';
            } else {
                return 'cloudy-sun';
            } 
        } else {
            return null;
        }
    }
}