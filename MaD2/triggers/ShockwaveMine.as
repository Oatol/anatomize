package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShockwaveMine extends Trigger
   {
      
      public function ShockwaveMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc4_:int = 0;
         var _loc6_:Number = 9000;
         if(_loc3_.length > 0)
         {
            param2.triggerState = 1;
         }
         if(param2.triggerState != 1)
         {
            return;
         }
         var _loc7_:int = Math.random() * -9;
         var _loc8_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * 4 * param2.size,bodyAngle * Vars.toDegrees + _loc7_ * 20);
         BoxUtils.randomSlopeParticles("shock",_loc8_,pixelCenter);
         var _loc9_:b2Body = Spawn.circle(_loc8_.x,_loc8_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
         userData(_loc9_.GetUserData()).ghost = true;
         userData(_loc9_.GetUserData()).killOnContact = true;
         userData(_loc9_.GetUserData()).trigger = new Tesla();
         userData(_loc9_.GetUserData()).triggerRadius = 50;
         userData(_loc9_.GetUserData()).triggered = true;
         userData(_loc9_.GetUserData()).triggerLock = true;
         userData(_loc9_.GetUserData()).zerograv = true;
         _loc9_.SetLinearVelocity(new b2Vec2((-pixelCenter.x + _loc8_.x) * -0.1,(-pixelCenter.y + _loc8_.y) * -0.1));
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.trigger = new Disintegrate("shock",100,20);
         }
      }
   }
}

