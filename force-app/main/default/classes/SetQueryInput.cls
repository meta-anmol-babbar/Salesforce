public class SetQueryInput 
{
    public String query{get;set;}
    public Boolean showQueryResultsArea{get;set;}
    public Boolean displayResult{get;set;}
 
    public SetQueryInput()
    {
        this.query = '';
        this.showQueryResultsArea = false;
    }

    public void execute()
    {
        if(!String.isBlank(query))
        {
            this.showQueryResultsArea = true;
        }
    }
}