public class SelectBillToContactController 
{  
    String record = null;
    public string oppId{get;set;}
    public List<Contact> conList{get;set;}
    
    public SelectBillToContactController(){
        oppId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference save() 
    {
        System.debug('in record save');
        System.debug('oppId' + oppId);
        record=getRecord();
        try{
            if(record.equals(null))
            {
                Apexpages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Please Select a record to save'));
                return null;   
            }
            else{
                
                Opportunity opp = [Select Id,BillToContact__c from Opportunity Where Id =: oppId];
                opp.BillToContact__c = record;
                update opp;
                PageReference pg = new PageReference('/'+opp.Id);
                pg.setRedirect(true);
                return pg;  
            }
        }
        catch(Exception e){
            Apexpages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Please Select a record to save in catch'));
            return null; 
        }
    }
    
    public PageReference clear()
    {
        System.debug('in record clear');
        System.debug('oppId' + oppId);
        try
        {
            Id newCon = null;    
            Opportunity opp = [Select Id,BillToContact__c from Opportunity Where Id =: oppId];
            opp.BillToContact__c = newCon;
            update opp;
            PageReference pg = new PageReference('/'+opp.Id);
            pg.setRedirect(true);
            return pg;    
        }
        catch(Exception e){
            Apexpages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'No Record Present '));
            return null; 
        }
    }
    
    public PageReference cancel() 
    {
        PageReference pg = new PageReference('/'+oppId);
        pg.setRedirect(true);
        return pg;
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        conList = [SELECT Id,FirstName, LastName, Title, Email FROM Contact WHERE AccountId IN (SELECT Manager__c FROM Opportunity WHERE id =: oppId)];
        
        for( Contact con:conList)
        {
            options.add(new SelectOption(con.Id,con.LastName));
        }
        return options;        
    }
    public void setRecord(String record) 
    { 
        this.record = record; 
    }
    public String getRecord()
    {
        return record;
    }
    
    
}