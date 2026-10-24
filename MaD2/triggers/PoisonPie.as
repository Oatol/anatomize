package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PoisonPie extends Trigger
   {
      
      public function PoisonPie()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_)
            {
               _loc5_.trigger = new Acided();
               _loc5_.triggerDuration = 240;
               _loc5_.triggered = true;
            }
         }
         param2.trigger = new Disintegrate("acid",100,30);
         sounds.play("acidburn",param1,pixelCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggered = true;
         return true;
      }
   }
}

