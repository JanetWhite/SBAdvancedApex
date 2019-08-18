/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
       CollaborationGroup cg = new CollaborationGroup(name='TEST'+Constants.INVENTORY_ANNOUNCEMENTS, CollaborationType='Public');
        return cg;
    }
    
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        system.assertEquals(updatedProduct.Quantity_Ordered__c, originalProduct.Quantity_Ordered__c + qtyOrdered);
    }


    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> prodList = new List<Product2>();
        List<Schema.PicklistEntry> familyList = Constants.PRODUCT_FAMILY;
        Integer j =0;
        for(integer i=0;i<cnt;i++){
            if(j == familyList.size()){
                j=0;
            }
            Product2 pr = new Product2(isActive=true,name=String.valueOf(datetime.now()+i),Initial_Inventory__c=10, family=familyList[j].getValue());
            prodList.add(pr);
            j++;
        }
        return prodList;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PriceBookEntry> pbeList = new List <PriceBookEntry>();
        for(Product2 prod : prods){
        PriceBookEntry pbe = new PriceBookEntry();
        			pbe.Unitprice = 10;
                    pbe.Product2Id = prod.Id;
                    pbe.IsActive = true;
                    pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pbeList.add(pbe);
        }
        return pbeList;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accList = new List<Account>();
        for(integer i=0;i<cnt;i++){
            Account acc = new Account(name=String.valueOf(datetime.now()+i));
            accList.add(acc);
        }
        return accList;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact>  ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> conList = new List<Contact>();
        for(integer i=0;i<cnt;i++){
            Contact con = new Contact(firstName='test'+i, lastName=String.valueOf(datetime.now()),accountId = accts[i].Id);
            conList.add(con);
        }
        return conList;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order>  ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orderList = new List<Order>();
            for(integer i=0;i<cnt;i++){
                orderList.add(new Order(accountId = accts[i].Id, Name=String.valueOf(datetime.now())+i,	Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,EffectiveDate=date.today(),status='	Draft'));
            }
        
        return orderList;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> oli = new List<OrderItem>();
        for(integer i=0;i<cnt;i++){
            oli.add(new orderItem(quantity=constants.DEFAULT_ROWS,OrderId=ords[i].Id, PricebookEntryId=pbes[i].Id, UnitPrice=pbes[i].UnitPrice));
        }
		
		return oli;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
			//ConstructCollaborationGroup
		List<Product2> prod = ConstructProducts(cnt);
        insert prod;
        List<PriceBookEntry> pbe = ConstructPricebookEntries(prod);
        insert pbe;
        List<Account> acc = ConstructAccounts(cnt);
        insert acc;
        List<Contact> cons =  ConstructContacts(cnt,acc);
        insert cons;
        List<Order> orders = ConstructOrders(cnt, acc);
        insert orders;
        List<OrderItem> oli = ConstructOrderItems(cnt,pbe,orders);
        insert oli;
        
        
        
        
    }

}