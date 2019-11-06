public class SObjList {
    public static void getAllSObjectList(){
	list<schema.sObjectType> allObjects = Schema.getGlobalDescribe().Values();
	for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
    	system.debug(objTyp.getDescribe().getLabel());	
    	}
    }    
}