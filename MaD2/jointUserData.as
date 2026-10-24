package
{
   public class jointUserData
   {
      
      public var name:String;
      
      public var forceLimit:Number;
      
      public var upperAngle:Number;
      
      public var lowerAngle:Number;
      
      public var cuttable:Boolean;
      
      public var dead:Boolean;
      
      public var defaultUA:Number;
      
      public var defaultLA:Number;
      
      public var defaultFL:Number;
      
      public var lineWidth:Number = 2;
      
      public var lineColour:uint;
      
      public var lineAlpha:Number = 1;
      
      public var lineVisible:Boolean;
      
      public function jointUserData(param1:String)
      {
         super();
         this.name = param1;
         this.forceLimit = -1;
         this.cuttable = true;
         this.dead = false;
         this.lineVisible = true;
      }
   }
}

