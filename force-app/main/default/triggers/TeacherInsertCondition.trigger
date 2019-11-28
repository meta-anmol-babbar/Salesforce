trigger TeacherInsertCondition on Contact (before insert , before update) {
    for(Contact teacher : Trigger.new){
        if(teacher.Subject__c.contains('Hindi')){
            teacher.addError('Subject Hindi is not allowed');
        }
}
}