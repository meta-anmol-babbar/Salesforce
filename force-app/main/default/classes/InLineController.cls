public class InLineController {
    Public Contact cRec{get;set;}
    
    public InLineController(ApexPages.StandardController controller) {    
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {
            
            cRec = [select id, Name, OwnerId, AccountId, Title, Department, Phone, HomePhone, OtherPhone, MobilePhone, Fax, RecordType.Name
                    from Contact where id = :ApexPages.currentPage().getParameters().get('id')];
            
        }
    }
    
}