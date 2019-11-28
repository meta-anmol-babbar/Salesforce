trigger ClassCountIncrement on Student__c (after insert, after delete) {
    
    List<Class__C> classList = new List<Class__c>();
    Set<ID> newIds = new Set<ID>();
    if(Trigger.isDelete)
    {
        for(Integer i = 0; i < Trigger.old.Size(); i++)
        {
            newIds.add(Trigger.old[i].class__c);
        }
    }
    else if(Trigger.isInsert)
    {
        for(Integer i = 0; i < Trigger.new.Size(); i++)
        {
            newIds.add(Trigger.new[i].class__c);
        }
        
    }
    
    classList = [SELECT (SELECT Name FROM Students__r) from class__c WHERE Id IN: newIds];
    for(Class__c Cla : classList)
    {
        Cla.My_Count__c = Cla.Students__r.size();
    }
    upsert classList;
}