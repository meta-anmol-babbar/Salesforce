global with sharing class ManageClassController
{
    public Boolean editBlock{get;set;}
    public Id stuClassId{get;set;}
    
    public List<Class__c> classes{
        get
        {
            classes = [Select Id, Name, Name__c, Class_Teacher__c, MaxSize__c from Class__c];
            return classes;    
        }
        
        set;
    }
    
    public String classNo {get;set;}
    public String className{get;set;}
    public String classMaxSize{get;set;}
    
    public Class__c stuClassDetails = new Class__c();
    
    public ManageClassController(){
        editBlock = false;   
    }
    
    public void edit()
    {
        editBlock = true;
        stuClassDetails = getStuClassDetails();
    }
    
    public PageReference saveDetails(){
        
        update stuClassDetails;
        return null;
    }
    
    public PageReference deleteCla()
    {System.debug(stuClassId);
        stuClassDetails = getStuClassDetails();
        Database.delete(stuClassId);
        return null;
    }
    
    public Class__c getStuClassDetails(){
        
        stuClassDetails = [Select Id, Name, Name__c, Class_Teacher__c, MaxSize__c from Class__c Where Id = :stuClassId limit 1];
        return stuClassDetails;
    }
}