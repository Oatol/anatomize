package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DestroyOnColour extends Trigger
   {
      
      public function DestroyOnColour()
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
         super.trigger(param1,param2);
         if(triggerState == 0)
         {
            return;
         }
         if(ud.triggerParticle)
         {
            BoxUtils.randomParticlesOnBody(body,ud.triggerParticle);
         }
         ud.triggered = false;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:int = 0;
         if(param1.IsStatic())
         {
            return false;
         }
         if(param3.name == ud.triggerColour)
         {
            userData(param1.GetUserData()).dead = true;
            if(ud.triggerParticle)
            {
               _loc7_ = 0;
               while(_loc7_ < Math.random() * 20 + 5)
               {
                  BoxUtils.randomParticlesOnBody(param1,ud.triggerParticle);
                  _loc7_++;
               }
            }
         }
         ud.triggered = true;
         ud.triggerState = 1;
         return false;
      }
   }
}

