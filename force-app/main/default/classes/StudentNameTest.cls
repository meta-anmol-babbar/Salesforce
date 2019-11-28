@isTest
public class StudentNameTest
{	
    @testSetup
    public static void setup()
    {
        List<Student__c> stuList = new List<Student__c>();
        Class__c testClass = new Class__c(Name = 'TestClass', Name__c = 'Test');
        insert testClass;
        
        for(Integer i=0; i<20; i++) 
        {
            Student__c con = new Student__c(Name='Test' + i, Last_Name__c = 'Student' +i,
                                            Class__c = testClass.Id);
            stuList.add(con);
        }
        insert stuList;
    }
    
    @isTest static void testStudentName()
    {
        Id classId = [Select Id from Class__c where Name = 'TestClass'][0].id;
        Test.startTest();
        List<Student__c> TestStuName = StudentName.GetStudentByClassId(classId);
        Test.stopTest();
        System.assertEquals(20, TestStuName.size());
    } 
    
    @isTest static void testStudentNameWithNull()
    {
        Id classId = [Select Id from Class__c where Name = 'TestClass'][0].id;
        Test.startTest();
        try{
            List<Student__c> TestStuName = StudentName.GetStudentByClassId(null);
        }
        catch(NullPointerException npe){
            System.assertEquals('Please enter a valid clas Id, It is null' , npe.getMessage()); 
        }
        
        Test.stopTest();
        
    } 
    
    @isTest static void testStudentMap()
    {
        Test.startTest();
        Map<String, List<Id>> classStudentMap = StudentName.GetStudentMap(); 
        Test.stopTest();
        List<Id> studentsList =  classStudentMap.get('TestClass');
        
        System.assertEquals(studentsList.size(), classStudentMap.get('TestClass').size());     
    }
}