@isTest
public class WorkingDayCalculationTest {
    
    @isTest static void testWorkingDayCalculation()
    {
        date date1 = Date.newInstance(2019,10,31);
        date date2 = Date.newInstance(2019,11,17);
        Test.startTest();
        Integer WorkingDaysdays = WorkingDayCalculation.calculateWorkingDays(date1,date2);
        Test.stopTest();
        System.assertEquals(12,WorkingDaysdays);
    }
    
    @isTest static void testWorkingDayCalculationEnDateLess()
    {
        date date1= Date.newInstance(2019,11,17);
        date date2= Date.newInstance(2019,10,31);
        Test.startTest();
        Integer WorkingDaysdays = WorkingDayCalculation.calculateWorkingDays(date1,date2);
        Test.stopTest();
        System.assertEquals(12,WorkingDaysdays);
    }
    
    @isTest static void testWorkingDayCalculationWithOneNullValue()
    {
        date date1 = null;
        date date2 = Date.newInstance(2019,11,17);
        Test.startTest();
        Integer WorkingDaysdays = WorkingDayCalculation.calculateWorkingDays(date1,date2);
        Test.stopTest();
        System.assertEquals(0,WorkingDaysdays);
    }
    
    @isTest static void testWorkingDayCalculationWithBothNullValue()
    {
        date date1 = null;
        date date2 = null;
        Test.startTest();
        Integer WorkingDaysdays = WorkingDayCalculation.calculateWorkingDays(date1,date2);
        Test.stopTest();
        System.assertEquals(0,WorkingDaysdays);
    }
}