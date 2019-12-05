@isTest
public class TestShoppingCartController 
{	
    @testSetup
    public static void setup()
    {
        List<Product2> productsList = new List<Product2>();
        
        for(Double i = 0; i < 101; i++)
        {
            Product2 newPro = new Product2(Name ='Test product' + i , ProductCode = 'PC ' + i, Product_Price__c = 5 + i ,
                                           Quantity_Available__c = Integer.valueof((math.random() * 10) ) + 5);
            
            productsList.add(newPro);
        }
        for(Double i = 0; i < 5; i++)
        {
            Product2 newPro = new Product2(Name ='Search' + i , ProductCode = 'PC ' + i, Product_Price__c = 5 + i ,
                                           Quantity_Available__c = Integer.valueof((math.random() * 10) ) + 5);
            
            productsList.add(newPro);
        }
        for(Double i = 0; i < 5; i++)
        {
            Product2 newPro = new Product2(Name ='New' + i , ProductCode = 'PC ' + i, Product_Price__c = 5 + i ,
                                           Quantity_Available__c = Integer.valueof((math.random() * 10)) + 5);
            
            productsList.add(newPro);
        }
        
        Product2 newPro = new Product2(Name ='ZeroQty' , ProductCode = 'PC ', Product_Price__c = 5,
                                       Quantity_Available__c = 0);
        productsList.add(newPro);
        
        insert productsList;
    }
    
    @isTest static void testNewPurchase()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        List<Product2> productsList = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c From Product2];
        List<ProudctsWrapper> wrapProList = new  List<ProudctsWrapper>();
        for(Product2 pro : productsList)
        {
            ProudctsWrapper product = new ProudctsWrapper(pro);
            wrapProList.add(product); 							 // making wrap products list from ShoppingCartController
        }
        
        Test.startTest();
        System.assert(scc.displayProducts , 'displayProducts is true');  //checking displayProuducts block 
        System.assertEquals(productsList, scc.productsList);
        //comparing product list size and wrapper list size
        System.assertEquals(productsList.size(), scc.wrapProductsList.size()); 	
        //comparing wrapper class default selected value   
        System.assert(!scc.wrapProductsListCopy.get(Integer.valueOf(math.random() * 100)).selected); 
        //checking default quantity
        System.assertEquals(1,scc.wrapProductsListCopy.get(Integer.valueOf(math.random() * 100)).quantity); 
        //   System.assertEquals(wrapProList, scc.wrapProductsList);
        System.assertEquals(wrapProList.size(), scc.allProductsMap.size());  //comparing map values
        //  System.assertEquals(wrapProList,  scc.wrapProductsListCopy);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testSearchProductsWithBlank()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        List<Product2> productsList = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c From Product2];
        
        scc.searchProducts();
        Test.startTest();
        System.assertEquals(productsList.size(), scc.wrapProductsListCopy.size());
        System.assertEquals(productsList.size(), scc.wrapProductsListCopy.size());
        Test.stopTest();
    }
    
    @isTest
    public static void testSearchProductsWithValue()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        List<Product2> productsListWithSe = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c From Product2
                                             Where Name Like 'Se%'];
        
        String search = 'Se';
        scc.proSearch = search;
        scc.searchProducts();
        Test.startTest();
        System.assertEquals(5, scc.wrapProductsListCopy.size());
        System.assertEquals(productsListWithSe.size(), scc.wrapProductsListCopy.size());
        System.assert(!scc.wrapProductsListCopy.get(2).selected);
        Test.stopTest();
    }
    
    
    @isTest
    public static void testAddToCartNewWithQtyZero()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        Product2 productsListWithQtyZero = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                                            From Product2 Where Name = 'ZeroQty' ][0];
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'N%' ][0]; 
        
        ProudctsWrapper productWrapWithQtyZero  = scc.allProductsMap.get(productsListWithQtyZero.Id);
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        
        productWrap1.selected = true; 
        scc.addToCart();
        
        productWrapWithQtyZero.selected = true;
        scc.addToCart();
        
        
        Test.startTest();
        System.assertEquals(1, scc.itemsInCart.size());
        System.assert(!productWrapWithQtyZero.selected, 'unchek of selected product'); 
        System.assertEquals(product1.Product_Price__c * 1 , scc.cartTotal);
        System.assertEquals(1, scc.mapItemsInCart.size());
        Test.stopTest();     
    }
    
    @isTest
    public static void testAddToCartEmptyWithQtyZero()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        Product2 productsListWithQtyZero = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                                            From Product2 Where Name = 'ZeroQty' ][0];
        
        ProudctsWrapper productWrapWithQtyZero  = scc.allProductsMap.get(productsListWithQtyZero.Id);
        
        productWrapWithQtyZero.selected = true;
        scc.addToCart();
        
        Test.startTest();
        System.assertEquals(0, scc.itemsInCart.size());
        System.assertEquals(0.0, scc.cartTotal);
        System.assert(!productWrapWithQtyZero.selected, 'unchek of selected product'); 
        System.assertEquals(0, scc.mapItemsInCart.size());
        Test.stopTest();     
    }
    
    @isTest
    public static void testAddToCartWithNoPrevious()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        Final Double qty1 = productWrap1.pro.Quantity_Available__c;
        Final Double qty2 = productWrap2.pro.Quantity_Available__c;
        
        productWrap1.selected = true;
        productWrap2.selected = true; 
        
        scc.addToCart();
        
        Test.startTest();
        System.assert(scc.displayCart,'cheking display cart block is visible');
        System.assertEquals(2 , scc.itemsInCart.size());
        System.assert(!productWrap1.selected, 'unchek of selected product');
        System.assert(!productWrap2.selected, 'unchek of selected product');
        System.assertEquals(qty1 - 1, scc.allProductsMap.get(product1.Id).pro.Quantity_Available__c);
        System.assertEquals(qty2 - 1, scc.allProductsMap.get(product2.Id).pro.Quantity_Available__c);
        System.assertEquals(2, scc.mapItemsInCart.size());
        Test.stopTest();     
    }
    
    @isTest
    public static void testAddToCartWithPrevious()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        Product2 product3 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'N%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        ProudctsWrapper productWrap3 = scc.allProductsMap.get(product3.Id);
        Final Double qty1 = productWrap1.pro.Quantity_Available__c;
        Final Double qty2 = productWrap2.pro.Quantity_Available__c;
        Final Double qty3 = productWrap3.pro.Quantity_Available__c;
        
        productWrap1.selected = true;
        productWrap2.selected = true; 
        scc.addToCart();
        
        productWrap1.selected = true;
        productWrap2.selected = true; 
        productWrap3.selected = true;
        scc.addToCart();
        
        Test.startTest();
        System.assert(scc.displayCart,'cheking display cart block is visible');
        System.assertEquals(3 , scc.itemsInCart.size());
        System.assert(!productWrap1.selected, 'unchek of selected product');
        System.assert(!productWrap2.selected, 'unchek of selected product');
        System.assert(!productWrap3.selected, 'unchek of selected product');
        
        System.assertEquals(qty1 - 2, scc.allProductsMap.get(product1.Id).pro.Quantity_Available__c);
        System.assertEquals(qty2 - 2, scc.allProductsMap.get(product2.Id).pro.Quantity_Available__c);
        System.assertEquals(qty3 - 1, scc.allProductsMap.get(product3.Id).pro.Quantity_Available__c);
        System.assertEquals(3, scc.mapItemsInCart.size());
        Test.stopTest();     
    }
    
    
    @isTest
    public static void testGetQty()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        Final Double avlQty = productWrap1.pro.Quantity_Available__c;
        
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        
        scc.itemId = product1.Id;
        scc.qty =  2 ;
        ProudctsWrapper cartProduct = scc.mapItemsInCart.get(product1.Id);
        cartProduct.quantity = scc.qty + 1;
        scc.getQty();
        
        
        Test.startTest();
        ProudctsWrapper cartProductToTest = scc.mapItemsInCart.get(product1.Id);
        ProudctsWrapper allProductItemToTest = scc.allProductsMap.get(product1.Id);
        System.assertEquals(3 , cartProductToTest.quantity);
        System.assertEquals(avlQty - 3 , allProductItemToTest.pro.Quantity_Available__c);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetQtyNegitive()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        Final Double avlQty = productWrap1.pro.Quantity_Available__c;
        
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        
        //Adding same products 3 times
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        
        scc.itemId = product1.Id;
        scc.qty =  3;
        ProudctsWrapper cartProduct = scc.mapItemsInCart.get(product1.Id);
        cartProduct.quantity = scc.qty - 2;
        scc.getQty();
        
        Test.startTest();
        ProudctsWrapper cartProductToTest = scc.mapItemsInCart.get(product1.Id);
        ProudctsWrapper allProductItemToTest = scc.allProductsMap.get(product1.Id);
        System.assertEquals(1 , cartProductToTest.quantity);
        System.assertEquals(avlQty - 1 , allProductItemToTest.pro.Quantity_Available__c);
        Test.stopTest();
        
    }   
    
    @isTest
    public static void testGetQtyNegitiveQtyGreaterThenAvailable()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        Final Double avlQty = productWrap1.pro.Quantity_Available__c;
        
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        
        //Adding same products 3 times
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        
        scc.itemId = product1.Id;
        scc.qty =  3;
        ProudctsWrapper cartProduct = scc.mapItemsInCart.get(product1.Id);
        cartProduct.quantity = scc.qty + 22;
        scc.getQty();
        
        Test.startTest();
        ProudctsWrapper cartProductToTest = scc.mapItemsInCart.get(product1.Id);
        ProudctsWrapper allProductItemToTest = scc.allProductsMap.get(product1.Id);
        System.assertEquals(3 , cartProductToTest.quantity);
        System.assertEquals(avlQty - 3 , allProductItemToTest.pro.Quantity_Available__c);
        Test.stopTest();
        
    }  
    
    @isTest
    public static void testGetQtyNegitiveQtyZero()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        Final Double avlQty = productWrap1.pro.Quantity_Available__c;
        
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        
        //Adding same 2 products 3 times
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        
        scc.itemId = product1.Id;
        scc.qty =  3;
        ProudctsWrapper cartProduct = scc.mapItemsInCart.get(product1.Id);
        cartProduct.quantity = 0;
        scc.getQty();
        
        Test.startTest();
        ProudctsWrapper cartProductToTest = scc.mapItemsInCart.get(product1.Id);
        ProudctsWrapper allProductItemToTest = scc.allProductsMap.get(product1.Id);
        System.assertEquals(1 , scc.itemsInCart.size());
        System.assertEquals(avlQty , allProductItemToTest.pro.Quantity_Available__c);
        Test.stopTest();
        
    }
    
    @isTest
    public static void testDeleteCartItem()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        Final Double avlQty = productWrap1.pro.Quantity_Available__c;
        
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        
        //Adding same 2 products 3 times
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        
        scc.itemId = product1.Id;
        SCC.deleteCartItem();
        
        Test.startTest();
        ProudctsWrapper allProductItemToTest = scc.allProductsMap.get(product1.Id);
        System.assertEquals(1 , scc.itemsInCart.size());
        System.assertEquals(avlQty , allProductItemToTest.pro.Quantity_Available__c);
        Test.stopTest();
    }
    
    @isTest
    public static void testDeleteAllCartItem()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        
        Final Double avlQty1 = productWrap1.pro.Quantity_Available__c;
        Final Double avlQty2 = productWrap2.pro.Quantity_Available__c;
        
        //Adding same 2 products 3 times
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        productWrap1.selected = productWrap2.selected = true;         
        scc.addToCart();
        
        scc.itemId = product1.Id;
        scc.deleteCartItem();
        scc.itemId = product2.Id;
        scc.deleteCartItem();
        
        Test.startTest();
        ProudctsWrapper allProductItemToTest1 = scc.allProductsMap.get(product1.Id);
        ProudctsWrapper allProductItemToTest2 = scc.allProductsMap.get(product2.Id);
        System.assertEquals(0 , scc.itemsInCart.size());
        System.assertEquals(avlQty1 , allProductItemToTest1.pro.Quantity_Available__c);
        System.assertEquals(avlQty2 , allProductItemToTest2.pro.Quantity_Available__c);
        Test.stopTest();
    }
    
    @isTest
    public static void testCheckout()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        Final Double qty1 = productWrap1.pro.Quantity_Available__c;
        Final Double qty2 = productWrap2.pro.Quantity_Available__c;
        
        productWrap1.selected = true;
        productWrap2.selected = true; 
        
        scc.addToCart();
        scc.checkout();
        
        Test.startTest();
        System.assert(!scc.displayCart,'cheking display cart block is not visible');
        System.assert(!scc.displayProducts,'cheking display products block is not visible');
        System.assert(!scc.puchaseHistory,'cheking purchase history block is not visible');
        System.assert(scc.checkoutPage,'cheking checkout block is visible');
        System.assertEquals(2 , scc.itemsInCart.size());
        System.assert(!productWrap1.selected, 'unchek of selected product');
        System.assert(!productWrap2.selected, 'unchek of selected product');
        System.assertEquals(qty1 - 1, scc.allProductsMap.get(product1.Id).pro.Quantity_Available__c);
        System.assertEquals(qty2 - 1, scc.allProductsMap.get(product2.Id).pro.Quantity_Available__c);
        System.assertEquals(2, scc.mapItemsInCart.size());
        Test.stopTest();     
    }
    
    @isTest
    public static void testPlaceOrder()
    {
        ShoppingCartController scc = new ShoppingCartController();
        scc.newPurchase();
        
        Product2 product1 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'T%' ][0]; 
        Product2 product2 = [Select Id, Name, ProductCode, Description, Product_Price__c, Quantity_Available__c 
                             From Product2 Where Name Like 'S%' ][0]; 
        
        ProudctsWrapper productWrap1 = scc.allProductsMap.get(product1.Id);
        ProudctsWrapper productWrap2 = scc.allProductsMap.get(product2.Id);
        Final Double qty1 = productWrap1.pro.Quantity_Available__c;
        Final Double qty2 = productWrap2.pro.Quantity_Available__c;
        
        productWrap1.selected = true;
        productWrap2.selected = true; 
        
        scc.addToCart();
        scc.checkout();
        scc.placeOrder();
        
        Test.startTest();
        System.assert(!scc.displayCart,'cheking display cart block is not visible');
        System.assert(!scc.displayProducts,'cheking display products block is not visible');
        System.assert(!scc.puchaseHistory,'cheking purchase history block is not visible');
        System.assert(scc.checkoutPage,'cheking checkout block is visible');
        System.assertEquals(product1.Product_Price__c + product2.Product_Price__c , scc.cartTotal);
        System.assertEquals(2 , scc.itemsInCart.size());
        System.assert(!productWrap1.selected, 'unchek of selected product');
        System.assert(!productWrap2.selected, 'unchek of selected product');
        System.assertEquals(qty1 - 1, scc.allProductsMap.get(product1.Id).pro.Quantity_Available__c);
        System.assertEquals(qty2 - 1, scc.allProductsMap.get(product2.Id).pro.Quantity_Available__c);
        System.assertEquals(2, scc.mapItemsInCart.size());
        Test.stopTest();     
    }
}