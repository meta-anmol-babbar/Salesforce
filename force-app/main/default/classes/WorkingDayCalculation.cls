public class WorkingDayCalculation  
{  
    public static Integer calculateWorkingDays(Date startDate, Date endDate)  
    {                  
        Integer workingDays = 0;  
        
        for(Integer i=0; i <= startDate.daysBetween(endDate); i++)  
        {  
            Date dt = startDate + i;  
            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
            String todayDay = currDate.format('EEEE');  
            if(todayDay != 'Saturday' && todayDay !='Sunday')  
            {  
                workingDays = workingDays + 1;  
            }         
        }  
        
        System.debug('Working days '+workingDays);  
        return workingDays;  
    }  
}