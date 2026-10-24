package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MeltAndPour extends PourSpawnProjectile
   {
      
      public function MeltAndPour()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         param2.layer = 2;
         GraphicUtils.addGraphicToLayer(param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            _loc5_.temperature += param2.triggerForce;
         }
         if(Math.random() > 0.95)
         {
            _loc6_ = "smoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc6_ = param2.pfx.getParticle();
            }
            else
            {
               if(Math.random() > 0.9)
               {
                  _loc6_ = "fire3";
               }
               if(Math.random() > 0.9)
               {
                  _loc6_ = "fire2";
               }
               if(Math.random() > 0.9)
               {
                  _loc6_ = "bigSmoke";
               }
            }
            BoxUtils.randomParticlesOnBody(param1,_loc6_);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         if(param1.IsStatic())
         {
            return false;
         }
         if(param3.name == ud.triggerColour)
         {
            userData(param1.GetUserData()).dead = true;
            _loc7_ = "smoke";
            _loc8_ = 0;
            while(_loc8_ < 10)
            {
               if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
               {
                  _loc7_ = ud.pfx.getParticle();
               }
               else
               {
                  if(Math.random() > 0.9)
                  {
                     _loc7_ = "fire3";
                  }
                  if(Math.random() > 0.9)
                  {
                     _loc7_ = "fire2";
                  }
                  if(Math.random() > 0.9)
                  {
                     _loc7_ = "bigSmoke";
                  }
               }
               BoxUtils.randomParticlesOnBody(param1,_loc7_);
               _loc8_++;
            }
         }
         return false;
      }
   }
}

