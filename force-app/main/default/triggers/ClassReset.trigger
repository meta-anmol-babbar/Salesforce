trigger ClassReset on Class__c (after update) 
{   
    List<Student__c> relStudents = [Select Id,Class__r.Id from Student__c  Where Class__r.Id IN :Trigger.New AND  Class__r.Custom_Status__c = 'Reset'];
    List <Student__c> studentsToDel = new List<Student__c>();
    
    for(Class__c classRecord : Trigger.new)
    {
       Class__c oldRecord = Trigger.oldMap.get(classRecord.Id);
        if(oldRecord.Custom_Status__c != 'Reset' && classRecord.Custom_Status__c == 'Reset')
        {
            for(Student__c stu : relStudents){
                if(stu.Class__r.Id == classRecord.Id){
                    StudentsToDel.add(stu);
                }
            }
        }
      
    }        
    delete StudentsToDel;
}