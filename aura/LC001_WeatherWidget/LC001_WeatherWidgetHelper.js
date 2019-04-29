({
    getAccountWeather : function(component, accountId) {
        var accountDBCall = component.get("c.getAccountGeoLocation");
        accountDBCall.setParams({ 
            "Id" : accountId
        });
        
        accountDBCall.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var account = response.getReturnValue();
                this.callWeatherWebservice(component, account.BillingLatitude, account.BillingLongitude);
            }
            else if (state === "INCOMPLETE") {
                console.log("The server didn’t return a response. The server might be down or the client might be offline.");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });     
        $A.enqueueAction(accountDBCall); 
    },
    
    callWeatherWebservice: function(component, latitude, longitude) {
        
        var restCall = component.get("c.getWeather");
        restCall.setParams({ 
            "latitude" : latitude,
            "longitude" : longitude
        });
        
        restCall.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var weather = response.getReturnValue();
                component.set("v.temperature", weather.temperature);
                component.set("v.humidity", weather.humidity);
                component.set("v.windSpeed", weather.windSpeed);
                component.set("v.clouds", weather.clouds);
                component.set("v.weatherState", weather.weatherState);
                this.setIconVisibility(component, weather.weatherState);
            }
            else if (state === "INCOMPLETE") {
                console.log("The server didn’t return a response. The server might be down or the client might be offline.");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });     
        $A.enqueueAction(restCall); 
    },
    
    setIconVisibility: function(component, weatherState) {
        var targetDiv = component.find(weatherState);
        $A.util.removeClass(targetDiv, 'hidden');
    },
    
    sendReport: function(component) {
        var mailReport = component.get("c.sendMailReport");
        mailReport.setParams({ 
            "objectName" : component.get('v.sObjectName'),
            "accountId" : component.get('v.recordId'),
            "temperature" : component.get('v.temperature'),
            "humidity" : component.get('v.humidity'),
            "windSpeed" : component.get('v.windSpeed'),
            "clouds" : component.get('v.clouds'),
            "weatherState" : component.get('v.weatherState')
        });
        
        mailReport.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Your report has been sent successfully."
                });
                toastEvent.fire();
                this.updateUserLastSentReportDate(component);
            }
            else if (state === "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "The server didn’t return a response. The server might be down or the client might be offline."
                });
                toastEvent.fire();
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "type": "error",
                                "message": "Error message: " + errors[0].message
                            });
                            toastEvent.fire();
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });     
        $A.enqueueAction(mailReport); 
    },
    
    updateUserLastSentReportDate: function(component) {
        var updateLastSentDate = component.get("c.updateLastSentReportDate");        
        updateLastSentDate.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
            }
            else if (state === "INCOMPLETE") {
                console.log("The server didn’t return a response. The server might be down or the client might be offline.");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });     
        $A.enqueueAction(updateLastSentDate); 
    }
})