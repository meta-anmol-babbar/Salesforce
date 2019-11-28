trigger OpportunityStageChange on Opportunity (before update) 
{
    for(Opportunity opp : Trigger.new)
    {
        Opportunity oldRecord = Trigger.oldMap.get(opp.Id);
        
        if(!'Closed Won'.equalsIgnoreCase(oldRecord.StageName))
        {
            if(!'Closed Lost'.equalsIgnoreCase(oldRecord.StageName))
            {
                
                if('Closed Won'.equalsIgnoreCase(opp.StageName) || ('Closed Lost'.equalsIgnoreCase(opp.StageName)))
                {
                    opp.CloseDate = date.today();
                }
            }
        }
    }
}