@isTest
public class SObjListTest { 
    @isTest
    public static void GetObjectsInOrgtestAny()
    {
        Test.startTest();
        List<String> listOfSObject = SObjList.getAllSObjectList();
        Test.stopTest();
        System.assert(listOfSObject.contains('Class'));  
    }
    public static void GetObjectsInOrgtestAll()
    {
        Test.startTest();
        List<String> listOfSObject = SObjList.getAllSObjectList();
        Test.stopTest();
        List<Schema.SObjectType> sObjects = Schema.getGlobalDescribe().Values();
        System.assertEquals(sObjects.size(), listOfSObject.size());  
    }    
}