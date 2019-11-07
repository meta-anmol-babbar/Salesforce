public class WorkingDays {
	 public void getWorkingDays(){
        Date date1 = Date.newInstance(2019,10,31);
		Date date2 = Date.newInstance(2019,11,17);
        Integer noOfWorkingDays=0;
        String day1;
        String day2;
         if(!day1.equalsIgnoreCase('saturday') || !day1.equalsIgnoreCase('sunday')){
         date1 = date1.addDays(1);
         day1 = getDay(date1);
         }
         while(!day1.equalsIgnoreCase('saturday') || !day1.equalsIgnoreCase('sunday') ){
             noOfWorkingDays++;
             System.debug('day 1' + noOfWorkingDays);
              date1 = date1.addDays(1);
         	  day1 = getDay(date1);
            }
         
        if(!day2.equalsIgnoreCase('saturday') || !day2.equalsIgnoreCase('sunday')){
         date1 = date2.addDays(-1);
         day1 = getDay(date2);
         }
         while(!day2.equalsIgnoreCase('saturday') || !day2.equalsIgnoreCase('sunday') ){
              noOfWorkingDays++;
              date2 = date1.addDays(-1);
         	  day2 = getDay(date2);
            }
         Integer totalDays = date1.daysBetween(date2);
         Integer totalWeeks = (Integer)Math.floor((Double)totalDays/7);
         noOfWorkingDays += (totalWeeks*5);                                 
         
         System.debug('Working days' + noOfWorkingDays);
    
           }        
    public String getDay(date getDayFrom ){
        Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
		String dayOfWeek=dt.format('EEEE');
		return dayOfWeek;
    } 
}