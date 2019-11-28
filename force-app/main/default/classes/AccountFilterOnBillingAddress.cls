public class AccountFilterOnBillingAddress 
{    
    public Integer noOfAccounts{get; set;}
    public String searchOnBillCity{get; set;}
    public String searchOnBillState{get; set;}
    public String searchOnBillCountry{get; set;}
    public String query = '';
    public List<Account> result{get; set;}
    public Integer ResultSize{get;set;}
    public Integer pageNumber{get;set;}
    public Integer pageSize{get;set;}
    public Boolean hasNext{get;set;}
    public Boolean hasPrevious{get;set;}
    
    
    public ApexPages.StandardSetController stCon{get;set;}
    
    public void searchAccounts(){
        query = ''; 
        query += 'Select Name,BillingCity,BillingState,BillingCountry from Account ';
        
        if(String.isBlank(searchOnBillCity) && String.isBlank(searchOnBillState) && String.isBlank(searchOnBillCountry))
        {
            
        }
        else {
            query += 'Where ';
            if(String.isNotBlank(searchOnBillCity))
            {
                query += 'BillingCity like \'' + searchOnBillCity + '%\' And ';
            }
            if(String.isNotBlank(searchOnBillState))
            {
                query += 'BillingState like \'' + searchOnBillState + '%\' And ';
            }
            if(String.isNotBlank(searchOnBillCountry))
            {
                query += 'BillingCountry like \'' + searchOnBillCountry + '%\' ';
            }
        }
        
        if(query.endsWithIgnoreCase('And '))
        {
            query = query.substring(0, query.length()-4);
        }
        System.debug(query);
        
        stCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        
        ResultSize= stCon.getRecords().size();
        if(noOfAccounts != 0)
        {
            stCon.setPageSize(Integer.valueOf(noOfAccounts));
        }
        else
        {
            stCon.setPageSize(10);
            noOfAccounts = 10;
        }
        
        pageSize=stCon.getPageSize();        
        result = (List<Account>)stCon.getRecords();
        getPageDetails();
        
    }
    
    public void first() 
    {
        stCon.first();
        result = (List<Account>)stCon.getRecords();
        getPageDetails();
    }
    
    public void last() 
    {
        stCon.last();
        result = (List<Account>)stCon.getRecords();   
        getPageDetails();
    }
    
    public void previous() 
    {
        stCon.previous();
        result = (List<Account>)stCon.getRecords(); 
        getPageDetails();
        
    }
    
    public void next() 
    {
        stCon.next();
        result = (List<Account>)stCon.getRecords(); 
        getPageDetails();
    }  
    
    public void getPageDetails(){
        pageNumber=stCon.getPageNumber();
        hasNext=stCon.getHasNext();
       
        hasPrevious= stCon.getHasPrevious();
       
    }
}