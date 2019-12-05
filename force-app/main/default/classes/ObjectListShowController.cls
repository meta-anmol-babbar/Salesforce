public class ObjectListShowController 
{
    public String queryToBeExecuted = '';
    public List<String> fieldsList{get;set;}
    public String sortBy = '';
    public Integer DesiredPage{get;set;}
    public Boolean isSortingLinkClicked = false;
    
    public ApexPages.StandardSetController setCon
    {
        get
        {
            if(setCon == null)
            {
                List<sObject> displayFields = new List<sObject>();
                displayFields = getDisplayFields(queryToBeExecuted);
                if(displayFields != null)
                {
                    setCon = new ApexPages.StandardSetController(displayFields);
                    setCon.setPageSize(10);
                }
            }
            return setCon;
        }
        set;
    }
    
    public ObjectListShowController()
    {
        this.queryToBeExecuted = '';
        this.sortBy = '';
        System.debug(this.DesiredPage);
    }
    
    public String getQueryToBeExecuted()
    {
        return this.queryToBeExecuted;
    }
    
    public void setQueryToBeExecuted(String query)
    {
        if(!this.queryToBeExecuted.equalsIgnoreCase(query))
        {
            this.queryToBeExecuted = query;
            this.setCon = null;
        }
    }
    
    
    public void sortByMethod()
    {
        this.setCon = null;
        this.isSortingLinkClicked = true;
    }
    
    public void setSortBy(String value)
    {
        this.sortBy = value;
    }
    
    public String getSortBy()
    {
        return this.sortBy;
    }
    
    public List<sObject> getRecordsList()
    {
        if(setCon != null)
        {
            this.DesiredPage = setCon.getPageNumber();
            return setCon.getRecords();
        }
        else
        {
            return null;
        }
    }
    
    private String createQuery(String query)
    {
        String orderedQuery = query;        
        if(isSortingLinkClicked && String.isNotBlank(this.getSortBy()))
        {
            if(query.containsIgnoreCase('order by'))
            {
                orderedQuery = orderedQuery.substring(0, query.indexOfIgnoreCase('order by') - 1);
            }
            orderedQuery = orderedQuery + ' order by ' + this.getSortBy();
        }
        return orderedQuery;
        
    }
    
    private List<sObject> executeQuery(String query)
    {
        String orderedQuery = createQuery(query);
        System.debug(orderedQuery);
        List<sObject> sObjectList = new List<sObject>();
        try
        {
            sObjectList = Database.query(orderedQuery);
            
        }
        catch(Exception excp)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, excp.getMessage())); 
            return null;
        }
        return sObjectList;
    }
    
    public List<sObject> getDisplayFields(String query)
    {
        List<sObject> records = executeQuery(query);
        if(records == null)
        {
            return null;
        }
        else
        {
            if(records.isEmpty())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records found'));
                records = new List<sObject>();
            }
            else
            {                
                debugFields(records);                 
            }
            
            return records; 
        }
    }  
    
    public void debugFields(List<sObject> objs) {
        Map<String, Object> fieldValues = new  Map<String, Object>();
        
        for (sObject obj : objs) {
            fieldValues = obj.getPopulatedFieldsAsMap();
        }
        this.fieldsList = new List<String>();
        this.fieldsList.addAll(fieldValues.keySet()); 
    }
    public void jumpToPage()
    {
        this.setCon.setPageNumber(DesiredPage);
    }
}