global class AccountProcessor {
    @future 
    global static void countContacts(List<Id> accountList){
        List<Account> acc = [Select Id, Name from Account Where Id IN :accountList];
        for(Account theAccount  :acc){ 
            Integer contactsCount=0;
            contactsCount=[Select Count() from Contact where AccountId =: theAccount.Id];
            
            System.debug('Account/Count:'+ theAccount.Name +' '+contactsCount);
            
            theAccount.Number_of_Contacts__c= contactsCount;
            update theAccount;
            
        }
    }
}