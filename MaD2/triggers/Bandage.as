package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Bandage extends Trigger
   {
      
      public function Bandage()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_.alive)
         {
            return false;
         }
         _loc7_.health += 5;
         if(_loc7_.bleeding.length > 0)
         {
            _loc7_.bleeding = [];
         }
         var _loc8_:String = "heal";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc8_ = ud.pfx.getParticle();
         }
         GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,"papa",body.GetLinearVelocity().x * 0.1,body.GetLinearVelocity().y * 0.1,1,1);
         ud.dead = true;
         return true;
      }
   }
}

