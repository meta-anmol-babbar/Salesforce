public class getId {
    public static void getClassId(){
        List<Class__c> classId = [Select ID from Class__c where Name Like 'sci%'];
        for(Class__c c : classId){
            System.debug(c.Id);
        }
    }
}