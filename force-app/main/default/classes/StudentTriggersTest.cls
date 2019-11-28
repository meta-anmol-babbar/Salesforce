@isTest
public class StudentTriggersTest
{
 @testSetup
    public static void setup()
    {
        Class__c testClass = new Class__c(Name = 'TestClass', Name__c = 'Test', MaxSize__c = 5 );
        insert testClass;
        
        List<Student__c> students = new List<Student__c>();
        for(Integer i=0; i<5; i++) 
        {
            Student__c con = new Student__c(Name='Test' + i, Last_Name__c = 'Student' +i,
                                            Class__c = testClass.Id);
            students.add(con);
        }
        insert students;
    }
    
     @isTest static void testClassLimitFail()
    {
        Id classId = [Select Id from Class__c where Name = 'TestClass'][0].id;
        Student__c con = new Student__c(Name='new Test', Last_Name__c = ' new Student',
                                            Class__c = classId);
        Test.startTest();
        Database.SaveResult result = Database.insert(con,false);
        Test.stopTest();
        System.assertEquals('Class Full...!!!', result.getErrors()[0].getMessage());
    } 
    @isTest static void testClassLimitSuccess()
    {
        Class__c classId = [Select Id,MaxSize__c from Class__c where Name = 'TestClass'][0];
        classId.MaxSize__c = 10;
        update classId;
        
        Student__c con = new Student__c(Name='new Test', Last_Name__c = ' new Student',
                                            Class__c = classId.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(con,false);
        Test.stopTest();
        System.assert(result.isSuccess());
    } 
      @isTest static void testdeleteStudent()
    {
        List<Class__c> classId = [Select Id from Class__c where Name = 'TestClass'];
        List<Student__c> stuList = [Select Id, Class__r.id from Student__c Where Class__r.id IN :classId  ];
        
        Test.startTest();
        Database.DeleteResult result = Database.delete(stuList[0],false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }
    
}