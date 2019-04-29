({
    doInit : function(component, event, helper) {
        var objectName = component.get('v.sObjectName');
        if(objectName === 'Account') {
            helper.getAccountWeather(component, component.get('v.recordId'));
        } else {
            if(navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
            }
            
            function successFunction(position) {
                helper.callWeatherWebservice(component, position.coords.latitude, position.coords.longitude);
            }
            
            //TODO: gestion du code erreur et erreur associée
            function errorFunction(positionError) {
                component.set('v.errorMessage', positionError.message);
            }
        }
    },
    
    sendMail : function(component, event, helper) {
        helper.sendReport(component);
    }
})