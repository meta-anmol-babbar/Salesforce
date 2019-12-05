public class ProudctsWrapper {
    
    public Product2 pro {get;set;}
    public Boolean selected {get; set;}
    public Integer quantity{get;set;}
    
    public ProudctsWrapper(Product2 pro)
    {
       // System.debug('here in Wrapper');
        this.pro = pro ;
        selected = false;
        quantity = 1;
       }
}