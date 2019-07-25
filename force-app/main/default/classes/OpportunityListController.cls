public class OpportunityListController {
    public List<oppWrapper> wr  	 	{set;get;}
    public string           sPro 	 	{set;get;}
    public string           sPrice 	 	{set;get;}
    public PricebookEntry   priceBe     {set;get;}
 
//  --------------------------------------Constructor---------------------------------------------------------------------------------------------------   
    public OpportunityListController(){
        wr = new List<oppWrapper>();
            }
 
//----------------------------------------------Add Rows------------------------------------------------------------------------------------------------
    public void addRows(){
        wr.add(new oppWrapper());
    }
    
//---------------------------------------------------------Save Rows in Database-------------------------------------------------------------------------
    
  public PageReference savePro(){
        List<OpportunityLineItem> opli=new List<OpportunityLineItem>();
  integer i =0;
  for (oppWrapper wrap : wr)
  {
      
      sPro = wr[i].pri1.Product2Id;
      sPrice = wr[i].pri1.Pricebook2Id;
      priceBe = [Select Id, Pricebook2Id, Product2Id, UnitPrice, ProductCode From PriceBookEntry where Product2Id =:sPro AND 
                 Pricebook2Id=:sPrice];
      wr[i].o1.PricebookEntryId = priceBe.Id;
      wrap.o1.OpportunityId = '0063600000ER400';     
      opli.add(wrap.o1);
      i = i+1;
 }
   
  insert opli;
  return new PageReference('/'+'0063600000ER400');
 }

//------------------------------------------------------------Wrapper class------------------------------------------------------------------------------
    
public class oppWrapper {
        public OpportunityLineItem   o1     {set;get;}
        public Product2              pr1    {set;get;}
        public PricebookEntry        pri1   {set;get;}
        public Opportunity           opp    {set;get;}
        
        
        public oppWrapper(){
            o1    = new OpportunityLineItem();
            pr1   = new Product2();
            pri1  = new PricebookEntry();
            opp   = new Opportunity();
        }
        
    }
}