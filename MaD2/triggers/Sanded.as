package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Sanded extends Trigger
   {
      
      public function Sanded()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.trigger(param1,param2);
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            Body.Damage(param1,Math.random() * 3.6 + 0.8);
            if(param2.bleeding.length > 0)
            {
               param2.bleeding = [];
            }
            if(param2.health <= 10)
            {
               if(param1.GetMass() < 0.5)
               {
                  Body.Disintegrate(param1,"dust",20,2,2);
                  return;
               }
               Body.brittle(param1);
               sounds.play("crash",param1,pixelCenter,0.1 + Math.random() * 0.1);
            }
            if(Math.random() > 0.9)
            {
               _loc3_ = Math.random() * param2.width - param2.width * 0.5;
               _loc4_ = Math.random() * param2.height - param2.height * 0.5;
               _loc5_ = bodyCenter.x * Physics.scale + _loc3_ * Math.cos(bodyAngle) - _loc4_ * Math.sin(bodyAngle);
               _loc6_ = bodyCenter.y * Physics.scale + _loc3_ * Math.sin(bodyAngle) + _loc4_ * Math.cos(bodyAngle);
               GameState.particles.addParticles(_loc5_,_loc6_,1,"dust",0,Math.random() * 2,0,0);
               if(Math.random() > 0.9)
               {
                  sounds.play("tinyhiss",param1,pixelCenter,0.5);
                  if(Math.random() > 0.9)
                  {
                     sounds.play("crash",param1,pixelCenter,0.15);
                  }
               }
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         this.trigger(body,ud);
         return true;
      }
   }
}

