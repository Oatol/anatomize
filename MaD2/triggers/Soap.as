package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class Soap extends Trigger
   {
      
      public function Soap()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc10_:String = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         var _loc8_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc8_)
         {
            _loc8_.colorTransform(_loc8_.rect,new ColorTransform(1,1,1,0.9));
         }
         var _loc9_:int = 0;
         while(_loc9_ < Math.random() * 10)
         {
            _loc10_ = "bubbles";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc10_ = ud.pfx.getParticle();
            }
            GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,_loc10_,body.GetLinearVelocity().x * 0.1,body.GetLinearVelocity().y * 0.1,Math.random() * 5,Math.random() * 5);
            _loc9_++;
         }
         return true;
      }
   }
}

