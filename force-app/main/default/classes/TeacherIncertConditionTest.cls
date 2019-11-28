@isTest
public class TeacherIncertConditionTest {

     @isTest static void testSubjectHindiOnInsert()
     {
         Contact con = new Contact(LastName = 'test' , Subject__c='English;Hindi');
         
         Test.startTest();
         Database.SaveResult result = Database.insert(con,false);
         Test.stopTest();
         System.assertEquals('Subject Hindi is not allowed', result.getErrors()[0].getMessage());
     }
    
     @isTest static void testSubjectHindiOnUpdate()
     {
         Contact con = new Contact(LastName = 'test' , Subject__c='English');
         insert con;
         
         con.Subject__c = 'English;Hindi';
             
         Test.startTest();
         Database.SaveResult result = Database.update(con,false);
         Test.stopTest();
         System.assertEquals('Subject Hindi is not allowed', result.getErrors()[0].getMessage());
     }
    
    @isTest static void testSubjectHindiOnInsertSuccess()
     {
         Contact con = new Contact(LastName = 'test' , Subject__c='English');
                    
         Test.startTest();
         Database.SaveResult result = Database.insert(con,false);
         Test.stopTest();
         System.assert(result.isSuccess());
     }
    
    @isTest static void testSubjectHindiOnUpdateSuccess()
     {
         Contact con = new Contact(LastName = 'test' , Subject__c='English');
         insert con;
         
         con.Subject__c = 'English;maths';
             
         Test.startTest();
         Database.SaveResult result = Database.update(con,false);
         Test.stopTest();
         System.assert(result.isSuccess());
     }
}