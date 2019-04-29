/**
 * @author Majid MAÏSSA
 * @date 28/04/2019
 * @description Datas Manager 002 - Account management
 */

public with sharing class DM002_Account {

     /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method retrieving the latitude and longitude of an Account by it's Id.
     * @param AccountId The Id of the Account.
     * @return Account The retrieved Account with it's latitude and longitude.
     */ 
    public Account getAccountById(String AccountId) {
        Account retrievedAccount = new Account();
        
        try {
            retrievedAccount = [Select Id, BillingLatitude, BillingLongitude FROM Account Where Id=: AccountId];
        }catch(QueryException exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
        }
        
        return retrievedAccount;
    }
}