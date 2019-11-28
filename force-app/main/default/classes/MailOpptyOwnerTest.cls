@IsTest
public class MailOpptyOwnerTest 
{
    
    @IsTest
    public static void mailTestWithNoOppty()
    {
        
        List<Opportunity> opportunitiesList = new List<Opportunity>();
        Date closeDate = Date.today().addDays(-7);
        for (Integer i=0; i<10; i++) {
            Opportunity o = new Opportunity(
                Name = 'Opportunity ' + i,
                CloseDate = closeDate,
                StageName = 'Prospecting'
            );
            opportunitiesList.add(o);
        }
        insert opportunitiesList;
        
        
        Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>(opportunitiesList);
        List<Id> opptyIds = new List<Id>(opptyMap.keySet());
        Test.startTest();
        MailOpptyOwner mail = new MailOpptyOwner();
       	String sch = '00 43 11 20 11 ?';
		String jobID = System.schedule('Test Mail', sch,mail);
        CronTrigger ct = [SELECT Id,  TimesTriggered
                              FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();
        List<Task> taskList = [SELECT Id FROM Task WHERE WhatId IN :opptyIds];
        System.assertEquals(0, ct.TimesTriggered);
        //System.assertEquals(opptyIds.size(), taskList.size(), 'Tasks were not created');
    }
    
    @IsTest
    public static void mailTestWithOppty()
    {
        
        List<Opportunity> opportunitiesList = new List<Opportunity>();
        Date closeDate = Date.today().addDays(-70);
        for (Integer i=0; i<10; i++) {
            Opportunity o = new Opportunity(
                Name = 'Opportunity ' + i,
                CloseDate = closeDate,
                StageName = 'Prospecting'
            );
            opportunitiesList.add(o);
        }
        insert opportunitiesList;
        
        
        Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>(opportunitiesList);
        List<Id> opptyIds = new List<Id>(opptyMap.keySet());
        Test.startTest();
        MailOpptyOwner mail = new MailOpptyOwner();
       	String sch = '00 00 00 20 11 ?';
		String jobID = System.schedule('Test Mail', sch,mail);
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();
        List<Task> taskList = [SELECT Id FROM Task WHERE WhatId IN :opptyIds];
        //System.assertEquals(10, ct.TimesTriggered);
        //System.assertEquals(opptyIds.size(), taskList.size(), 'Test Mail');
        System.assertEquals('2019-11-20 00:00:00', 
                                String.valueOf(ct.NextFireTime));
    }
}