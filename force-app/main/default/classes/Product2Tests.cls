@isTest 
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    static TestMethod void Product2Extension_UnitTest(){
        PageReference pageRef = Page.Product2New;
        Test.setCurrentPage(pageRef);
       
        product2 prod = new product2();
        ApexPages.StandardController std = new ApexPages.StandardController(prod);
        Product2Extension controller = new Product2Extension(std);
        
        //check the rows are initialised
        System.Assert(controller.productsToInsert.size() == Constants.DEFAULT_ROWS);
        //click add rows and check the value doubles
        controller.AddRows();
        System.Assert(controller.productsToInsert.size() == Constants.DEFAULT_ROWS*2);
		
        for(Integer i=0;i<5;i++){
            controller.productsToInsert[i].productRecord.Name=String.ValueOf(dateTime.now())+i;
            controller.productsToInsert[i].productRecord.Family='Side';
            controller.productsToInsert[i].productRecord.isActive=true;
            controller.productsToInsert[i].pricebookEntryRecord.UnitPrice=99;
            controller.productsToInsert[i].productRecord.Initial_Inventory__c=10;
        }
        system.debug('controller.productsToInsert = ' + controller.productsToInsert);
        test.startTest();
        controller.save();
        system.assertEquals(5, [select count() from product2]);
        controller.GetInventory();
        test.stopTest();
    }
     
    static TestMethod void product2Trigger_UnitTest (){
        //setup test products + collaborationGroup
        List<Product2> prods = TestDataFactory.ConstructProducts(10);
        insert prods;
        CollaborationGroup cg = TestDataFactory.ConstructCollaborationGroup();
        
        //amend products to enter trigger
        for(Product2 p : prods){
            p.Quantity_Ordered__c = 8;
        }
        update prods;
        //assert connect api announcement is created
        
    }

}