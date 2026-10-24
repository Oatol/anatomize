package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Minifigure extends Transmute
   {
      
      public function Minifigure()
      {
         super();
         item = "ragdoll";
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Vector.<Array> = GameState.objects.spawnSkin;
         var _loc4_:Number = GameState.objects.spawnScale;
         GameState.objects.spawnScale = param2.size;
         GameState.objects.spawnSkin = param2.skin;
         super.trigger(param1,param2);
         GameState.objects.spawnSkin = _loc3_;
         GameState.objects.spawnScale = _loc4_;
      }
   }
}

