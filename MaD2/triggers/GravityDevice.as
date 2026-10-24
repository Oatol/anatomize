package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GravityDevice extends Trigger
   {
      
      public function GravityDevice()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = 50;
         var _loc4_:String = "gravity";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc4_ = param2.pfx.getParticle();
         }
         var _loc5_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ - Math.random() * Math.random() * Math.random() * _loc3_,Math.random() * 360);
         GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc4_,0,triggerForce * 2,2,2);
         var _loc6_:Vector.<b2Body> = param2.connected.slice();
         for each(_loc7_ in _loc6_)
         {
            _loc7_.WakeUp();
            _loc7_.ApplyForce(new b2Vec2(0,-Vars.gravity * _loc7_.GetMass() * -triggerForce),_loc7_.GetWorldCenter());
         }
      }
   }
}

