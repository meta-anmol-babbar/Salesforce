@isTest
public class SetQueryInputTest 
{
    @isTest
    public static void testExecuteQueryEmpty()
    {
        SetQueryInput setQuery = new SetQueryInput();
        setQuery.query = '';
        setQuery.execute();
        Test.startTest();
        System.assertEquals(false, setQuery.showQueryResultsArea, 'Result Area was visible');
        Test.stopTest();
    }
    
     @isTest
    public static void testExecuteQueryNotEmpty()
    {
        SetQueryInput setQuery = new SetQueryInput();
        setQuery.query = 'SELECT Id, Name FROM Account';
        setQuery.execute();
        Test.startTest();
        System.assert(setQuery.showQueryResultsArea);
        Test.stopTest();
    }
}