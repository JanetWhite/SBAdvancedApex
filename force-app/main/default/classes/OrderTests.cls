@isTest 
private class OrderTests {

	@TestSetup
    public static void SetupTestData(){
        TestDataFactory.InsertTestData(5);
    }
    
    /*Finally, create a new test method named OrderUpdate_UnitTest in OrderTests. 
This method must activate the Orders created in your SetupTestData method using the 
ACTIVATED_ORDER_STATUS constant and then use the VerifyQuantityOrdered method to verify 
that the Quantity Ordered field on Products was increased by the trigger.*/
    @isTest
    public static void OrderUpdate_UnitTest(){
        Set<Id> prodIds = new Set<Id>();
        Map<Id, Product2> prodBefore = new Map<Id, Product2>();
        Map<Id, Product2> prodAfter = new Map<Id, Product2>();
        SetupTestData();
        List<Order> orders = [select id, status from order];
        
        for(Order o : orders){
            o.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        prodBefore = new Map<Id,Product2>([Select Id, Quantity_Ordered__c from Product2]);
        update orders;
        prodAfter = new Map<Id,Product2>([Select Id, Quantity_Ordered__c from Product2]);
        
        for(Product2 prod : prodBefore.values()){
            TestDataFactory.VerifyQuantityOrdered(prod, prodAfter.get(prod.Id), 5);
        }
    }
    
    static TestMethod void OrderExtension_UnitTest(){
        PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);
       
        Order ord = new order();
        ApexPages.StandardController std = new ApexPages.StandardController(ord);
        OrderExtension controller = new OrderExtension(std);
        
        //Check for a new record overItemList is initialised
        Integer productCount = [select count() from priceBookEntry];
        System.AssertEquals(controller.orderItemList.size(), productCount);
        
        //create data then edit one order
        SetupTestData();
        List<Order> orders = [select id from order];
        pageRef.getParameters().put('Id', String.valueOf(orders[0].Id));
        std = new ApexPages.StandardController(ord);
        controller = new OrderExtension(std);
        OrderExtension.QueryOrderRecord(orders[0].Id);
        
        //check the controller now has 1 orderItem
        system.debug(controller.orderItemMap.size());
        System.AssertEquals(controller.orderItemMap.size(), 5);
        
        //change quantity
        controller.orderItemList[0].Quantity = 2;
        controller.OnFieldChange();
        List<SelectOption> options = controller.GetFamilyOptions();
        system.assertEquals(options.size(),Constants.PRODUCT_FAMILY.size()+1);
        controller.selectedFamily = Constants.PRODUCT_FAMILY[0].getValue();
        Integer prodType = [select count() from product2 where family =: Constants.PRODUCT_FAMILY[0].getValue()];
        //check orderItemlist has correct number of items add one for the test product
        system.assertEquals(prodType+1, controller.orderItemList.size());
        controller.save();
            
        //test pagination
        	controller.first();
            controller.next();
            controller.previous();
            controller.last();
            controller.GetHasPrevious();
            controller.GetHasNext();
        	controller.GetTotalPages();
        	controller.GetPageNumber();
        
        
        controller.SelectFamily();
        }

}