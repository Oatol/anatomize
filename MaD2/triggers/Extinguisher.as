package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Extinguisher extends Trigger
   {
      
      public function Extinguisher()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.5)
         {
            _loc3_ = Properties.objTemp("extinguish");
            _loc3_.triggered = true;
            _loc3_.trigger = new Water();
            _loc3_.projectileName = "ext";
            Water(_loc3_.trigger).setParticle("gas");
            _loc4_ = param2.triggerPos.Copy();
            _loc4_.Multiply(param2.size);
            if(param2.flipped)
            {
               _loc4_.x *= -1;
            }
            _loc5_ = BoxUtils.rotateVec(_loc4_,bodyAngle);
            _loc6_ = bodyAngle + Vars.PI * 0.5;
            _loc7_ = Spawn.circle(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y,2 * param2.size,_loc3_,[1,1,0]);
            _loc7_.SetLinearVelocity(new b2Vec2(param2.triggerForce * 10 * param2.size * Math.cos(_loc6_) + Math.random() * 4 - 2,param2.triggerForce * 10 * param2.size * Math.sin(_loc6_) + Math.random() * 4 - 2));
         }
      }
   }
}

