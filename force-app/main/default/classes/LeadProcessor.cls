global class LeadProcessor implements Database.Batchable<sObject> {
	 global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name FROM Lead'
        );
	}
    
     global void execute(Database.BatchableContext bc, List<Lead> leads){
        // process each batch of records
        List<Lead> contacts = new List<Lead>();
        for (Lead l : leads) {
            l.LeadSource='Dreamforce';
        }
        update contacts;
    }    
    
    global void finish(Database.BatchableContext bc){
      
    }
}