public class SerializeStudent 
{   
    public String jsonStudent{get;set;}
    
    public SerializeStudent()
    {
        jsonStudent = jsonStudent(); 
    }
    public static String jsonStudent()
    {
        List<Student__c> students = [Select Id,Name,Last_Name__c, Class__r.Name From Student__c];
        String jsonStu = JSON.serialize(students);
        return jsonStu;
    }
}