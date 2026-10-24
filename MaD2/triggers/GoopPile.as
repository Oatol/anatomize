package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GoopPile extends Trigger
   {
      
      internal var cloneBody:b2Body;
      
      public function GoopPile()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:String = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.5 && (TimeLord.speed >= 1 || TimeLord.speed < 1 && Math.random() * TimeLord.speed < TimeLord.speed * 0.1))
         {
            _loc3_ = "moss";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc3_ = param2.pfx.getParticle();
            }
            _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,Math.random() * 20 * param2.size,-Math.random() * 360 + bodyAngle * Vars.toDegrees);
            _loc5_ = bodyAngle - Vars.PI * 0.5;
            GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc3_,0,0,Math.sin(_loc5_),Math.cos(_loc5_));
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            _loc6_ = Body.Clone(this.cloneBody);
            if(_loc6_)
            {
               _loc6_.SetXForm(bodyCenter,bodyAngle);
            }
            param2.dead = true;
            Body.Disintegrate(param1,"moss",5,5,5);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         if(!userData(param1.GetUserData()).saveable)
         {
            return true;
         }
         this.cloneBody = param1;
         ud.triggered = true;
         ud.triggerLock = true;
         Joints.Distance("goop",body,param1,new b2Vec2(param1.GetPosition().x + Math.random() - 0.5,param1.GetPosition().y + Math.random() - 0.5),new b2Vec2(param1.GetPosition().x + Math.random() - 0.5,param1.GetPosition().y + Math.random() - 0.5),0,0.01);
         Joints.Distance("goop",body,param1,new b2Vec2(param1.GetPosition().x + Math.random() - 0.5,param1.GetPosition().y + Math.random() - 0.5),new b2Vec2(param1.GetPosition().x + Math.random() - 0.5,param1.GetPosition().y + Math.random() - 0.5),0,0.01);
         return true;
      }
   }
}

