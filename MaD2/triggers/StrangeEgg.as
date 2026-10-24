package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class StrangeEgg extends Trigger
   {
      
      public function StrangeEgg()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Number = Vars.objSize;
         var _loc4_:b2Body = GameState.objects.spawnObject("rawchicken",pixelCenter.x,pixelCenter.y,bodyAngle + Vars.PI * 0.5,param2.flipped,true);
         param2.triggerForce = 20;
         param2.triggerContact = 50;
         param2.trigger = new Egg(["CC9838","CCCCCC"],20,100);
      }
   }
}

