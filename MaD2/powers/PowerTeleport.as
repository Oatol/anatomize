package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerTeleport extends Power
   {
      
      public function PowerTeleport()
      {
         super(Tool.TELEPORT,"void","teleport");
         noThrowAmount = true;
         bodySound = "swish";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc5_:* = undefined;
         super.OnBodyPress(param1);
         var _loc2_:b2Vec2 = new b2Vec2((50 + Math.random() * 700) / Physics.scale,(50 + Math.random() * 500) / Physics.scale);
         var _loc3_:int = 0;
         while(_loc3_ < 20)
         {
            GameState.particles.addParticles(_loc2_.x * Physics.scale,_loc2_.y * Physics.scale,1,"void",0,0,4,4);
            _loc3_++;
         }
         var _loc4_:Array = BoxUtils.selectCompound(param1);
         for each(_loc5_ in _loc4_)
         {
            _loc5_.SetXForm(_loc2_,Math.random() * Math.PI * 2);
         }
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnProjectileThrow(param1,param2);
         if(!throwBody)
         {
            return;
         }
         userData(throwBody.GetUserData()).triggerRadius = 200;
      }
      
      override protected function ThrowUpdate(param1:b2Vec2) : void
      {
         super.ThrowUpdate(param1);
         throwProjectiles = 1;
      }
   }
}

