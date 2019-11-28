@isTest
public class OpportunityStageChangeTest {
    @isTest static void testOpportunityStageChangePrevNotClWonOrClLo(){
        
        Opportunity oppy = new Opportunity (Name = 'test oppty', CloseDate = Date.today().addDays(-10), StageName = 'Prospecting'); 
        insert oppy;        
        Test.startTest();
        oppy.StageName='Closed Won';
        update oppy;
        Test.stopTest();
        System.assertEquals(date.today(),[Select CloseDate from Opportunity where id =: oppy.Id][0].Closedate);
    }
    
    @isTest static void testOpportunityStageChange_PrevNotClWonOrClLo_NewNotClWonOrClLo(){
        
        Opportunity oppy = new Opportunity (Name = 'test oppty', CloseDate = Date.today().addDays(-10), StageName = 'Prospecting'); 
        insert oppy;        
        Test.startTest();
        oppy.StageName='Qualification';
        update oppy;
        Test.stopTest();
        System.assertEquals( Date.today().addDays(-10),[Select CloseDate from Opportunity where id =: oppy.Id][0].Closedate);
    }
    
    @isTest static void testOpportunityStageChangePrevClWonOrClLo(){
        
        Opportunity oppy = new Opportunity (Name = 'test oppty', CloseDate = Date.today().addDays(-10), StageName = 'Closed Won'); 
        insert oppy;
        
        Test.startTest();
        oppy.StageName='Closed Lost';
        update oppy;
        Test.stopTest();
   
        System.assertEquals(date.today().addDays(-10),[Select CloseDate from Opportunity where id =: oppy.Id][0].Closedate);
    }
}