package
{
   public class ItemData
   {
      
      internal var itemName:String;
      
      internal var itemScale:Number;
      
      internal var itemColours:Array;
      
      internal var itemVertices:Array;
      
      internal var itemAlphas:Array;
      
      public function ItemData(param1:String, param2:Number, param3:Array, param4:Array, param5:Array = null)
      {
         super();
         this.itemName = param1;
         this.itemScale = param2;
         this.itemColours = param3;
         this.itemVertices = param4;
         if(param5)
         {
            this.itemAlphas = param5;
         }
      }
   }
}

