@isTest
public class ClassDeleteNotAllowedTest
{	
    @testSetup
    public static void setup()
    {
        Class__c testClass = new Class__c(Name = 'TestClass', Name__c = 'Test', MaxSize__c = 150 );
        insert testClass;
        
        Class__c testClassMale = new Class__c(Name = 'TestClassMale', Name__c = 'Test', MaxSize__c = 150 );
        insert testClassMale;
        
        List<Student__c> studentsWithFemale = new List<Student__c>();
        List<Student__c> studentsOnlyMale = new List<Student__c>();
        
        for(Integer i=0; i<5; i++) 
        {
            Student__c stu = new Student__c(Name='Test' + i, Last_Name__c = 'Student' +i, Sex__c = 'Female',
                                            Class__c = testClass.Id);
            studentsWithFemale.add(stu);
        }
        
        for(Integer i=0; i<100; i++) 
        {
            Student__c stu = new Student__c(Name='Test' + i, Last_Name__c = 'Student' +i, Sex__c = 'Male',
                                            Class__c = testClass.Id);
            Student__c stu1 = new Student__c(Name='Test' + i, Last_Name__c = 'Student' +i, Sex__c = 'Male',
                                             Class__c = testClassMale.Id);
            studentsWithFemale.add(stu);
            studentsOnlyMale.add(stu1);
        }
        
        insert studentsWithFemale;
        insert studentsOnlyMale;
    }
    
    @isTest static void testClassDeleteNotAllowedWithFemale()
    {
        Id classId = [Select Id from Class__c where Name = 'TestClass'][0].id;
        Test.startTest();
        Database.DeleteResult result = Database.delete(classId, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assertEquals('This Class cannot delete...!!! More Then one Female Student Present', result.getErrors()[0].getMessage());
    }
    
    
    @isTest static void testClassDeleteNotAllowedWithMale()
    {
        Id classId = [Select Id from Class__c where Name = 'TestClassMale'][0].id;
        Test.startTest();
        Database.DeleteResult result = Database.delete(classId, false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }
    
    @isTest static void testClassDeleteNotAllowedWithNoStudent()
    {
        Class__c testClass = new Class__c(Name = 'TestClass', Name__c = 'Test', MaxSize__c = 150 );
        insert testClass;
        Test.startTest();
        Database.DeleteResult result = Database.delete(testClass.Id, false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }
}