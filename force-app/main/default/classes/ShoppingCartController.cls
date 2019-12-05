public class ShoppingCartController
{
    public List<Purchase_Order__c> PurchaseOrderList {get;set;}
    
    public List<ProudctsWrapper> wrapProductsList{get;set;}
    public List<ProudctsWrapper> wrapProductsListCopy{get;set;}
    public List<Product2> productsList{get;set;}
    public Map<Id, ProudctsWrapper> allProductsMap = new Map<Id, ProudctsWrapper>();
    public List<Purchase_Order_Line_Item__c> orderItems{get;set;}
    
    public List<ProudctsWrapper> itemsInCart{get;set;}
    public List<ProudctsWrapper> itemsInCartNew{get;set;}
    public Map<Id, ProudctsWrapper> mapItemsInCart = new Map<Id, ProudctsWrapper>();
    
    public Purchase_Order__c orderDetails{get;set;}
    public Double cartTotal {get;set;}
    public Id itemId{get;set;}
    public Boolean displayProducts{get;set;}
    public Boolean displayCart{get;set;}
    public Boolean checkoutPage{get;set;}
    public Boolean puchaseHistory{get;set;}
    public String proSearch{get;set;}
    public Integer qty{get;set;}
    Purchase_Order__c newOrder{get;set;}
    public Id invoiceNumber{get;set;}
    
    public Integer orResultSize{get;set;}
    public Integer orPageNumber{get;set;}
    public Integer orPageSize{get;set;}
    public Boolean orHasNext{get;set;}
    public Boolean orHasPrevious{get;set;}
    
    
    public ApexPages.StandardSetController ordersStCon{get;set;}
    
    public ShoppingCartController()
    {
        ordersStCon = new ApexPages.StandardSetController(Database.getQueryLocator('Select Id,Name,Order_Price__c, Status__c, CreatedDate  From Purchase_Order__c order By CreatedDate Desc'));
        orResultSize= ordersStCon.getRecords().size();
        ordersStCon.setPageSize(5);
        orPageSize = 5;
        PurchaseOrderList = (List<Purchase_Order__c>) ordersStCon.getRecords();
        getOrderPageDetails();
        
        proSearch = ''; 
        itemsInCart = new List<ProudctsWrapper>();
        cartTotal = 0;
        qty = 0;
        displayProducts = false;
        displayCart = false;
        checkoutPage=false;
        puchaseHistory = true;
        newOrder = new Purchase_Order__c();
        invoiceNumber = newOrder.Id;
    }
    
    public void newPurchase()
    {
        displayProducts = true;
        wrapProductsList = new List<ProudctsWrapper>();
        
        productsList = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c From Product2];
        
        for(Product2 pro : productsList)
        {
            ProudctsWrapper product = new ProudctsWrapper(pro);
            wrapProductsList.add(product);
            allProductsMap.put(product.pro.Id, product);
        }
        wrapProductsListCopy = wrapProductsList.clone();
        
    }
    
    public void searchProducts()
    {
        if(proSearch.equalsIgnoreCase(''))
        {
            wrapProductsListCopy = wrapProductsList.clone() ;  
        }
        else 
        {
            wrapProductsListCopy.clear();
            for(ProudctsWrapper wpl : wrapProductsList)
            {
                String check = wpl.pro.Name;
                if( check.startsWithIgnoreCase(proSearch) )
                {
                    wrapProductsListCopy.add(wpl);
                }
            }
        }
    }
    
    public void addToCart()
    {

        ProudctsWrapper cartItem;
        if(itemsInCart.isEmpty())
        {
            for(ProudctsWrapper wpl : wrapProductsList) 
            {
                if(wpl.selected == true) 
                {
                    displayCart = true;
                    wpl.selected = false;
                    if( wpl.pro.Quantity_Available__c > 0)
                    {
                        cartItem = new ProudctsWrapper(wpl.pro);
                        itemsInCart.add(cartItem);
                        cartTotal +=wpl.pro.Product_Price__c;
                        wpl.pro.Quantity_Available__c -= 1;
                        wpl.selected = false;
                        mapItemsInCart.put(cartItem.pro.Id, cartItem);
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Item Not Available'));
                    }
                }       
            }        
        }
        else 
        {
            Boolean flag = false;
            itemsInCartNew = new List<ProudctsWrapper>();
            for(ProudctsWrapper wpl : wrapProductsList) 
            {
                flag=false;
                if( wpl.selected == true )
                {
                    wpl.selected = false;
                    for(ProudctsWrapper item : itemsInCart )
                    {
                        system.debug(itemsInCart.size());
                        
                        if(item.pro.Id == wpl.pro.Id)
                        {
                            flag=true;
                            if( wpl.pro.Quantity_Available__c>0)
                            {
                                item.quantity += 1;   
                                cartTotal +=wpl.pro.Product_Price__c;
                                wpl.pro.Quantity_Available__c -= 1;
                                continue;
                            }
                            else
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Item Not Available'));
                            }
                        }
                    }
                    if(flag)
                    {
                        continue;
                    }
                    else                 
                    {
                        if(wpl.pro.Quantity_Available__c > 0){
                            cartItem = new ProudctsWrapper(wpl.pro);
                            itemsInCartNew.add(cartItem);
                            cartTotal +=wpl.pro.Product_Price__c;
                            wpl.pro.Quantity_Available__c -= 1; 
                            mapItemsInCart.put(cartItem.pro.Id, cartItem);
                        }
                        else
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Item Not Available'));
                        }
                    }
                }   
            }  
            itemsInCart.addAll(itemsInCartNew);  
        }
    }
    
    public void getQty()
    {
        Double qtyChange = 0;
        ProudctsWrapper cartPro = mapItemsInCart.get(itemId);
        ProudctsWrapper availProduct = allProductsMap.get(itemId) ;  // itemId stores product id value of this field
        
        qtyChange = cartPro.quantity - qty;   // qty stores previous value of this field
        if(qtyChange >= 0 )
        {
            if(availProduct.pro.Quantity_Available__c >= qtyChange )
            {
                cartTotal += (availProduct.pro.Product_Price__c * qtyChange);
                availProduct.pro.Quantity_Available__c = availProduct.pro.Quantity_Available__c - qtyChange;
                availProduct.quantity += (Integer)qtyChange;
            }
            else
            {
                cartPro.quantity = qty;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Item Not Available'));
            }
        }
        else
        {
            qtyChange = Math.abs(qtyChange); 
            cartTotal -= (availProduct.pro.Product_Price__c * qtyChange);
            availProduct.pro.Quantity_Available__c = availProduct.pro.Quantity_Available__c + qtyChange;
            availProduct.quantity -= (Integer)qtyChange;
            if(cartPro.quantity == 0)
            {
                deleteCartItem();
            }
        }
        System.debug('product qty ' + allProductsMap.get(itemId));
    }
    
    public void deleteCartItem()
    {
        ProudctsWrapper cartItem = mapItemsInCart.get(itemId);
        ProudctsWrapper product = allProductsMap.get(itemId);
        cartTotal -= (product.pro.Product_Price__c * cartItem.quantity);
        product.pro.Quantity_Available__c += cartItem.quantity; 
        
        mapItemsInCart.remove(itemId);
        if(mapItemsInCart.size() > 0)
        {
            itemsInCart = mapItemsInCart.values();
        }
        else
        {
            itemsInCart.clear();
          //  displayCart = false;
        }
    }
    
    public void checkout()
    {
        displayProducts = false;
        displayCart = false;
        puchaseHistory = false;
        checkoutPage = true;
    }
    
    public PageReference placeOrder()
    {
        orderItems = new List<Purchase_Order_Line_Item__c>();
        
        newOrder.Order_Price__c = cartTotal;
        insert newOrder;
        for( ProudctsWrapper item : itemsInCart)
        {
            Purchase_Order_Line_Item__c orderItem = new Purchase_Order_Line_Item__c();
            orderItem.Product__c = item.pro.Id;
            orderItem.Quantity__c = item.quantity;
            orderItem.Price__c = ( item.pro.Product_Price__c * item.quantity ) ;
            orderItem.Purchase_Order__c = newOrder.Id;
            orderItems.add(orderItem);
        }
        insert orderItems; 
        PageReference pageRef = new PageReference('/apex/ShoppingCart');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void orFirst() 
    {
        ordersStCon.first();
        PurchaseOrderList = (List<Purchase_Order__c>)ordersStCon.getRecords();
        getOrderPageDetails();
    }
    
    public void orLast() 
    {
        ordersStCon.last();
        PurchaseOrderList = (List<Purchase_Order__c>)ordersStCon.getRecords();   
        getOrderPageDetails();
    }
    
    public void orPrevious() 
    {
        ordersStCon.previous();
        PurchaseOrderList = (List<Purchase_Order__c>)ordersStCon.getRecords(); 
        getOrderPageDetails();
    }
    
    public void orNext() 
    {
        ordersStCon.next();
        PurchaseOrderList = (List<Purchase_Order__c>)ordersStCon.getRecords(); 
        getOrderPageDetails();
    }  
    
    public void getOrderPageDetails(){
        orPageNumber=ordersStCon.getPageNumber();
        orHasNext=ordersStCon.getHasNext();
        orHasPrevious= ordersStCon.getHasPrevious();
    }

}