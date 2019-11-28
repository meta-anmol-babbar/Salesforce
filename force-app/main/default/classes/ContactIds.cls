public class ContactIds 
{    
    public static String setContactIds(ID contactId)
    {
        Contact contactIdAccount = [SELECT Account.Id FROM Contact WHERE id =: contactId];
        Account relatedAccount = [Select Id , ContactIDs__c, ( Select Id From Contacts) From Account Where Id =: contactIdAccount.Account.Id]; 
        
        //List<Contact> allAccountRelatedContacts = [Select Id From Contact Where Contact.AccountId =: relatedAccount.Id];
        if(String.isBlank(relatedAccount.ContactIDs__c))
        {
            System.debug('true');
            relatedAccount.ContactIDs__c = '';
            Integer numberOfAccounts = relatedAccount.Contacts.size()-1;
            
            for( Integer i=0 ; i < numberOfAccounts; i++)
            {
                system.debug(relatedAccount.Contacts[i]); 
                relatedAccount.ContactIDs__c += relatedAccount.Contacts[i].Id + ' , ' ;
            }
            relatedAccount.ContactIDs__c += relatedAccount.Contacts[numberOfAccounts].Id;
        }
        else
        {
            System.debug('false');
            if((relatedAccount.ContactIDs__c).containsAny(contactId))
            {
            System.debug('');
            }
            else
            {
                relatedAccount.ContactIDs__c += ' , ' + contactId;
            }
        }
        
        upsert relatedAccount;
        return relatedAccount.ContactIDs__c ;
    }
}