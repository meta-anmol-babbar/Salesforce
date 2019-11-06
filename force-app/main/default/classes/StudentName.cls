public class StudentName {
    public static List<Student__c> GetStudentByClassId( String classId){
        List<Student__c> stuName = [SELECT Name FROM Student__c Where Class__r.Id =: classId];
    	
        for(Student__c stu: stuName){
            System.debug(stu.Name);
        }
        return stuName;
    }
    
    public static Map<String , List<Id>> GetStudentMap(){
        List<Id> classIdList = new List<Id>();
        List<Id> stuIdList = new List<Id>();
        
        Map<String, List<Id>> classStudentMap =  new Map<String, List<Id>>();
       
        List<Class__c> classList = [Select Id,Name from Class__c] ;
		List<Student__c> stuList = [SELECT Id,Name,Class__r.Id  FROM Student__c];
        
        //Fetching class ids
		for(Class__c cla : classList){
            List<Id> stuInClassList = new List<Id>();
            for(Student__c stu : stuList){
                if(cla.Id == stu.class__r.Id){           
            		stuInClassList.add(stu.Id);
                }
            }
            classStudentMap.put(cla.Name,stuInClassList);
        }
        System.debug(classStudentMap.values());
        
       return classStudentMap; 
        
    }
    
  
}