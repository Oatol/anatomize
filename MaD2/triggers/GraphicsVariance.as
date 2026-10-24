package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GraphicsVariance extends Trigger
   {
      
      protected var customs:Object;
      
      internal var background:Array;
      
      internal var normal:Array;
      
      internal var foreground:Array;
      
      protected var randoms:Array = [];
      
      public function GraphicsVariance()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
         this.background = GeneralUtils.toIntArray(this.customs["background"]);
         this.normal = GeneralUtils.toIntArray(this.customs["normal"]);
         this.foreground = GeneralUtils.toIntArray(this.customs["foreground"]);
         this.HideLayers(this.background);
         this.HideLayers(this.normal);
         this.HideLayers(this.foreground);
      }
      
      private function HideLayers(param1:Array) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         var _loc2_:int = Math.random() * param1.length >> 0;
         this.randoms.push(_loc2_);
         param1.splice(_loc2_,1);
         Body.HideLayers(body,param1);
      }
   }
}

