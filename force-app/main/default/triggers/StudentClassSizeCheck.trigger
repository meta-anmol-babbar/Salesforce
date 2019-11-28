trigger StudentClassSizeCheck on Student__c (before insert) {
    
    Integer i = 0;
        Set<ID> newIds = new Set<ID>();
        for(Student__c stu: Trigger.New)
        {
            newIds.add(stu.Class__c);
        }
        List<Class__C> classList = [SELECT MaxSize__c, NumberOfStudents__c from class__c WHERE Id IN: newIds];
        for(Class__c oneClass : classList)
        {
            if(oneClass.MaxSize__c == oneClass.NumberOfStudents__c)
            {
                Trigger.New[i].addError('Class Full...!!!');
            }
            i++;
        }
}