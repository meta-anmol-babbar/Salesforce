@isTest
public class UpdateOpportunityTest 
{
    
    @isTest public static void testUpdateOpportunitiesWithNull()
    {       
        List<Opportunity> opptsList = null;
        Test.startTest();
        List<Opportunity> intermidiateOpportunities = UpdateOpportunity.updateOpportunities(opptsList);
        Test.stopTest();
        
        List<Opportunity> opportunities = [SELECT Name, BillToContact__c, Manager__c, BillToContact__r.Name, BillToContact__r.Account.Name 
                                           From Opportunity];
        
        System.assertEquals(opportunities, intermidiateOpportunities); 
    }
    
    @isTest public static void testUpdateOpportunities()
    {
        Account acc = new Account(Name='Test Account', ContactIds__c = null);
        insert acc;
        Contact con = new Contact(LastName='Test contact', AccountId=acc.id);
        insert con;
        
        List<Opportunity> opptsList = new List<Opportunity>();
        for(Integer i=0 ;i< 50;i++)
        {
            Opportunity oppt = new Opportunity(Name='Test Opportunity', CloseDate = Date.today(),
                                               StageName = 'Prospecting' , BillToContact__c = con.Id);
            opptsList.add(oppt);
        }
        insert opptsList;
        
        Test.startTest();
        List<Opportunity> intermidiateOpportunities = UpdateOpportunity.updateOpportunities(opptsList);
        Test.stopTest();
        
        List<Opportunity> opportunities = [SELECT Name, BillToContact__c, Manager__c, BillToContact__r.Name, BillToContact__r.Account.Name 
                                           From Opportunity];
        
        System.assertEquals(opportunities, intermidiateOpportunities); 
    }
}