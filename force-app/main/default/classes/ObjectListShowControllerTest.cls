@isTest
public class ObjectListShowControllerTest 
{
    @testSetup
    static void testDataSetup()
    {
        List<Account> accounts = new List<Account>();
        for(Integer i = 1; i < 101; i++)
        {
            accounts.add(new Account(Name='Test Account ' + i));
        }
        insert accounts;
    }
    
    
    @isTest
    static void testSetQueryToBeExecuted()
    {
        ObjectListShowController obj = new ObjectListShowController();
        String testQuery = 'SELECT Id, Name FROM Account';
        obj.setQueryToBeExecuted(testQuery);
        test.startTest();
        System.assertEquals(testQuery, obj.getQueryToBeExecuted());
        Test.stopTest();
    }
    
    @isTest
    static void testDisplayFieldsIfRecordsFound()
    {        
        ObjectListShowController obj = new ObjectListShowController();
        String testQuery = 'SELECT Id, Name FROM Account';
        
        obj.setQueryToBeExecuted(testQuery);
        obj.setSortBy('Name');
        obj.sortByMethod();
        List<sObject> records = (List<sObject>)obj.getRecordsList();
        List<String> recordsFields = new List<String>(records[0].getPopulatedFieldsAsMap().keySet());
        List<String> fields = new List<String>();
        fields.add('Id');
        fields.add('Name');
        System.assertEquals(fields, recordsFields);
        System.assertEquals('Name', obj.sortBy);                
    }
    
    @isTest
    static void testDisplayFieldsQueryIncorrect()
    {
        ObjectListShowController obj = new ObjectListShowController();
        String testQuery = 'SELECT Id, Name FROM Amount WHERE';
        obj.setQueryToBeExecuted(testQuery);
        List<sObject> records = (List<sObject>)obj.getRecordsList(); 
        test.startTest();
        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'unexpected token: \'<EOF>\'');
        Test.stopTest();
    }
    
    @isTest
    static void testPageNumber()
    {
        ObjectListShowController obj = new ObjectListShowController();
        String testQuery = 'SELECT Id, Name FROM Account';
        obj.setQueryToBeExecuted(testQuery);
        obj.setSortBy('Name');
        List<sobject> records = (List<sobject>)obj.getRecordsList(); 
        obj.DesiredPage = 2;
        obj.jumpToPage();
        Test.startTest();
        System.assertEquals(2, obj.setCon.getPageNumber());
        Test.stopTest();
    }
    
}