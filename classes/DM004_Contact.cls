/**
 * @author Majid MAÏSSA
 * @date 28/04/2019
 * @description Datas Manager 004 - Contact management
 */

public with sharing class DM004_Contact {
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method retrieving the Email of all the Contacts related to an Account.
     * @param AccountId The Id of the Account.
     * @return List<Contact> The retrieved Contacts with their Email.
     */ 
    public List<Contact> getContactsEmailByAccountId(String accountId) {
        List<Contact> retrievedContacts = new List<Contact>();
        
        try {
            retrievedContacts = [Select Email FROM Contact WHERE AccountId =:accountId];
        }catch(QueryException exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
        }
        
        return retrievedContacts;
    }
}