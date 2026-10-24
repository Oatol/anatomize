package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class FirstAidKit extends Trigger
   {
      
      public function FirstAidKit()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:BitmapData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_.alive)
            {
               if(_loc5_.bleeding.length > 0)
               {
                  if(Math.random() > 0.9)
                  {
                     _loc5_.bleeding = [];
                  }
               }
               if(_loc5_.health < _loc5_.maxhealth)
               {
                  _loc5_.health += TimeLord.speed;
                  if(Math.random() > 0.9)
                  {
                     BoxUtils.randomParticlesOnBody(_loc4_,"heal");
                  }
               }
               if(_loc5_.trigger is Concussion)
               {
                  _loc5_.trigger = new Electrified();
                  _loc5_.triggerDuration = 4;
                  _loc5_.triggered = true;
               }
               if(_loc5_.temperature < 0)
               {
                  _loc5_.temperature = 1;
                  _loc5_.brittle = false;
               }
               if(_loc5_.temperature < 35)
               {
                  _loc5_.temperature += TimeLord.speed;
                  if(Math.random() > 0.9)
                  {
                     BoxUtils.randomParticlesOnBody(_loc4_,"fire3");
                  }
               }
               else if(_loc5_.temperature > 39)
               {
                  _loc5_.temperature -= TimeLord.speed;
                  if(Math.random() > 0.9)
                  {
                     BoxUtils.randomParticlesOnBody(_loc4_,"water");
                  }
               }
               _loc6_ = BoxUtils.getEffectBMD(_loc4_);
               if(_loc6_)
               {
                  _loc6_.colorTransform(_loc6_.rect,new ColorTransform(1,1,1,0.9));
               }
            }
         }
      }
   }
}

