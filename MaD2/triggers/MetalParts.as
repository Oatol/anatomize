package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MetalParts extends Trigger
   {
      
      public function MetalParts()
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
         if(!_loc7_.armour)
         {
            return false;
         }
         _loc7_.health = _loc7_.maxhealth;
         ud.trigger = new Disintegrate("cog",5,2);
         ud.triggered = true;
         var _loc8_:String = "sparkle";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc8_ = ud.pfx.getParticle();
         }
         var _loc9_:int = 0;
         while(_loc9_ < 100)
         {
            BoxUtils.randomParticlesOnBody(param1,_loc8_);
            _loc9_++;
         }
         return true;
      }
   }
}

