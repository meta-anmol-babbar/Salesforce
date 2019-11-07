public class UpdateOpportunity{
    
    public static void updateOpportunities(List<Opportunity> Opptys)
    {
        for(Opportunity opp: Opptys)
        {
            if(opp.BillToContact__c != null && opp.Manager__c == null)
            {
                Opportunity intermediateOpportunity = [SELECT Name, BillToContact__c, Manager__c, BillToContact__r.Name, BillToContact__r.Account.Name
                                                       FROM Opportunity WHERE BillToContact__c =: opp.BillToContact__c][0];
                intermediateOpportunity.Manager__c = intermediateOpportunity.BillToContact__r.AccountId;
                upsert intermediateOpportunity;
            }
        }
    }
}