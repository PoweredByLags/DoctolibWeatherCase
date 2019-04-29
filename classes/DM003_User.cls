/**
 * @author Majid MAÏSSA
 * @date 28/04/2019
 * @description Datas Manager 003 - User management
 */

public with sharing class DM003_User {
    
    private static final String STANDARD_USER_PROFILE = 'Standard User';
    private static final String STANDARD_SYSADMIN_PROFILE = 'System Administrator';
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method retrieving the Email of all the Users of the Org that have a "Standard User" or "System Administrator" Profile.
     * @return List<User> The retrieved Users with their Email.
     */ 
    public List<User> getOrgUsersEmail() {
        List<User> retrievedUsers = new List<User>();
        List<Profile> userProfiles = new List<Profile>();
        
        try {
            userProfiles = [Select Id FROM Profile WHERE Name=:STANDARD_USER_PROFILE OR Name =:STANDARD_SYSADMIN_PROFILE];
        }catch(QueryException exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
        }
        
        try {
            retrievedUsers = [Select Email FROM User WHERE ProfileId IN :userProfiles];
        }catch(QueryException exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
        }
        
        return retrievedUsers;
    }
    
    /**
     * @author Majid MAÏSSA
     * @date 28/04/2019
     * @description Method updating the Last Sent Report field of the Current User.
     */ 
    public void updateUserLastSentReportDate() {
        User userToUpdate = new User();
        try {
            userToUpdate = [Select Id FROM User WHERE Id=:UserInfo.getUserId()][0];
            userToUpdate.Last_Sent_Weather_Report__c = Date.today();
            update userToUpdate;
        }catch(DmlException exc) {
            System.debug(exc.getTypeName() + ' - at line: ' + exc.getLineNumber() + ': ' + exc.getMessage());
        }
    }
}