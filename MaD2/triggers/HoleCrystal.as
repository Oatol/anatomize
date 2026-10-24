package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class HoleCrystal extends Trigger
   {
      
      internal var holePos:b2Vec2 = new b2Vec2();
      
      protected var customs:Object;
      
      public function HoleCrystal()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:userData = null;
         var _loc6_:b2Body = null;
         var _loc7_:Number = NaN;
         var _loc8_:Sprite = null;
         var _loc9_:int = 0;
         var _loc10_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:String = "darkness";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         if(param2.triggerState == 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerState = 1;
               param2.triggerDuration = param2.originalTriggerDuration;
               this.holePos.x = pixelCenter.x + (Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5);
               this.holePos.y = pixelCenter.y + (Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5);
               param2.triggerDuration = param2.originalTriggerDuration;
            }
            return;
         }
         if(param2.triggerDuration <= 0)
         {
            param2.triggerState = -1;
         }
         else if(param2.triggerDuration > param2.originalTriggerDuration)
         {
            param2.triggerState = 0;
            if(Boolean(this.customs) && Boolean(this.customs["destroy"]))
            {
               _loc9_ = 0;
               while(_loc9_ < 10)
               {
                  BoxUtils.randomParticlesOnBody(param1,_loc3_,100);
                  _loc9_++;
               }
               param2.dead = true;
            }
         }
         if(param2.triggerState == 1)
         {
            param2.triggerDuration -= TimeLord.speed * 2;
         }
         else
         {
            param2.triggerDuration += TimeLord.speed * 0.5;
         }
         var _loc4_:* = Body.GetAroundPoint(this.holePos,20 * param2.size,20 * param2.size);
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_ != param1)
            {
               _loc5_ = userData(_loc6_.GetUserData());
               if(!(Boolean(_loc5_.trigger) && _loc5_.trigger is HoleCrystal))
               {
                  _loc5_.dead = true;
               }
            }
         }
         _loc7_ = 1 + (param2.originalTriggerDuration - param2.triggerDuration) * param2.triggerForce * 0.01;
         _loc4_ = Body.GetAround(param1,_loc7_,_loc7_);
         for each(_loc6_ in _loc4_)
         {
            _loc5_ = userData(_loc6_.GetUserData());
            if(!(Boolean(_loc5_.trigger) && _loc5_.trigger is HoleCrystal))
            {
               _loc5_.dead = true;
            }
         }
         _loc8_ = new Sprite();
         _loc8_.graphics.beginFill(0);
         _loc8_.graphics.drawCircle(GraphicUtils.camX(this.holePos.x) - camPos.x,GraphicUtils.camY(this.holePos.y) - camPos.y,_loc7_ * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc8_);
         _loc9_ = 0;
         while(_loc9_ < 10)
         {
            _loc10_ = GeneralUtils.pointOnCircle(this.holePos.x,this.holePos.y,_loc7_,Math.random() * 360);
            GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc3_,-this.holePos.x + _loc10_.x,-this.holePos.y + _loc10_.y,0,0);
            _loc9_++;
         }
      }
   }
}

