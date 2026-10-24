package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Wand extends Trigger
   {
      
      public function Wand()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = bodyCenter;
         var _loc4_:Number = Math.cos(bodyAngle + Math.PI / 2);
         var _loc5_:Number = Math.sin(bodyAngle + Math.PI / 2);
         var _loc6_:Number = _loc3_.x * Physics.scale;
         var _loc7_:Number = _loc3_.y * Physics.scale;
         var _loc8_:b2Vec2 = new b2Vec2(_loc6_ + triggerPos.y * param2.size * _loc4_,_loc7_ + triggerPos.y * param2.size * _loc5_);
         if(triggerState == 0)
         {
            if(bodyVel.Length() > 4 && Math.random() > 0.75)
            {
               GameState.particles.addSimpleParticles(_loc8_.x + Math.random() * 10 - 5,_loc8_.y + Math.random() * 10 - 5,1,4294967040,bodyVel.x * 0.2,bodyVel.y * 0.2,bodyVel.x * 0.05,bodyVel.y * 0.05);
            }
         }
         else if(triggerState == 1)
         {
            _loc9_ = 0;
            while(_loc9_ < 50)
            {
               GameState.particles.addSimpleParticles(_loc8_.x + Math.random() * 10 - 5,_loc8_.y + Math.random() * 10 - 5,1,4294967040,bodyVel.x * 0.2,bodyVel.y * 0.2,(bodyVel.x * 0.05 + 10) * param2.size,(bodyVel.y * 0.05 + 10) * param2.size);
               _loc9_++;
            }
            World.explode("wand",_loc8_,1000 * param2.size,param2.triggerRadius * param2.size,false,0,"wand");
            param2.triggerState = 2;
            Shadows.lightPos = _loc8_;
            Shadows.lightRadius = param2.triggerRadius;
            Main.instance.drawShadowsFor(Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size),4);
         }
         else if(triggerState == 2)
         {
            --param2.health;
            if(param2.health <= 0)
            {
               param2.health = 60;
               param2.triggerState = 0;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggered = true;
         if(ud.triggerState == 0)
         {
            ud.triggerState = 1;
         }
         return true;
      }
   }
}

