package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ScaleDisc extends Trigger
   {
      
      public function ScaleDisc()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != param2.body)
            {
               _loc5_ = param2.triggerForce * 0.01;
               if(_loc5_ > 2)
               {
                  _loc5_ = 2;
               }
               if(_loc5_ < 0.5)
               {
                  _loc5_ = 0.5;
               }
               Body.Scale(_loc4_,_loc5_,true);
            }
         }
         param2.dead = true;
         sounds.play("tesla_shoot",param1,pixelCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(userData(param1.GetUserData()).trigger is ScaleDisc)
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggered = true;
         return true;
      }
   }
}

