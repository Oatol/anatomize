package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class BubbleGum extends Jiggle
   {
      
      public function BubbleGum()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         super.trigger(param1,param2);
         if(param2.triggerState != 1)
         {
            return;
         }
         var _loc3_:Array = param2.triggerCustom.split(",");
         for each(_loc4_ in _loc3_)
         {
            Body.ApplyEffect(param1,_loc4_,pixelCenter);
         }
         Body.ModifyLayerAlpha(param1,[0,1,2,3],[0,0,0,0,0,0],[0,0,0,0,0,0]);
         param2.triggerState = 0;
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         ud.triggerState = 1;
      }
   }
}

