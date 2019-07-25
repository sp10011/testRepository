public class PDFcontroller {
  public String selval{get;set;}
  public list<selectOption> AllOpportunity  {get; set;}
  public List<OpportunityLineItem> products {get; set;} 

  public PDFcontroller(ApexPages.StandardController controller) {


// getting opportunity information
  AllOpportunity  =new list<selectOption>();
  list<opportunity> optns=[select id,name  from opportunity];
 for(opportunity op:optns){
 AllOpportunity.add(new selectOption(op.id,op.name));

}
}

//getting product details
  public void ShowRelatedProducts()
 { 
  products=new List<OpportunityLineItem>();
 for(opportunityLineItem product: [SELECT ServiceDate, Discount, ListPrice,  ProductCode,
                                   Quantity,UnitPrice,Subtotal,TotalPrice 
                                   FROM opportunityLineItem WHERE     opportunityid=:selval]){

         products.add(product);         
         System.debug('product details');                 
                                            }
    }
  }