package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class HoleInRadius extends Trigger
   {
      
      private var decals:Sprite;
      
      internal var holePos:b2Vec2 = new b2Vec2();
      
      public var visualOnly:Boolean = false;
      
      public function HoleInRadius()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.decals = ud.graphic.getChildByName("decals") as Sprite;
         ud.triggerState = -1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:Array = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:userData = null;
         var _loc12_:b2Body = null;
         var _loc13_:userData = null;
         var _loc14_:Array = null;
         var _loc15_:b2Body = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:b2Vec2 = null;
         super.trigger(param1,param2);
         this.decals.rotation += Math.random() * (Math.random() * 90 - 45);
         this.decals.scaleX = this.decals.scaleY = 1 + Math.random() * 0.2 - 0.1;
         this.decals.alpha = 1 - Math.random() * Math.random();
         if(param2.triggerState == 0)
         {
            if(param2.triggerDuration > 0)
            {
               param2.triggerDuration -= TimeLord.speed;
               return;
            }
            param2.triggerState = -1;
            return;
         }
         if(param2.triggerState == -1)
         {
            _loc9_ = Body.GetAround(param1,20 * param2.size,20 * param2.size);
            if(_loc9_.length > 0)
            {
               param2.triggerState = 1;
               param2.triggerDuration = 0;
            }
            return;
         }
         this.holePos.x = pixelCenter.x;
         this.holePos.y = pixelCenter.y;
         if(param2.triggerState == 1)
         {
            param2.triggerDuration += TimeLord.speed;
         }
         else
         {
            param2.triggerDuration -= TimeLord.speed * 2;
         }
         if(param2.triggerDuration >= param2.originalTriggerDuration)
         {
            param2.triggerState = 2;
         }
         else if(param2.triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            this.decals.alpha = 1;
            this.decals.scaleX = this.decals.scaleY = 1;
            param2.triggerState = 0;
            this.visualOnly = false;
            return;
         }
         var _loc3_:Number = param2.triggerRadius * (0.001 + param2.triggerDuration / param2.originalTriggerDuration);
         _loc3_ *= param2.triggerForce * 0.01;
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(0);
         _loc4_.graphics.drawCircle(GraphicUtils.camX(this.holePos.x) - camPos.x,GraphicUtils.camY(this.holePos.y) - camPos.y,_loc3_ * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc4_);
         this.decals.rotation = Math.random() * 360;
         this.decals.alpha = Math.random();
         this.decals.scaleX = this.decals.scaleY = _loc3_ * Main.instance.cam.scaleX * 0.2;
         var _loc5_:String = "darkness";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         var _loc6_:int = 0;
         while(_loc6_ < Math.random() * TimeLord.speed * 10)
         {
            _loc10_ = GeneralUtils.pointOnCircle(this.holePos.x,this.holePos.y,_loc3_,Math.random() * 360);
            GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc5_,-this.holePos.x + _loc10_.x,-this.holePos.y + _loc10_.y,0,0);
            _loc6_++;
         }
         if(this.visualOnly)
         {
            return;
         }
         var _loc7_:Array = Body.GetAround(param1,_loc3_,_loc3_);
         for each(_loc8_ in _loc7_)
         {
            _loc11_ = userData(_loc8_.GetUserData());
            if(!(Boolean(_loc11_.trigger) && _loc11_.trigger is HoleCrystal))
            {
               if(param2.connected.length > 0)
               {
                  _loc12_ = param2.connected[0];
                  if(_loc12_)
                  {
                     _loc13_ = userData(_loc12_.GetUserData());
                     if(Boolean(_loc13_.trigger && _loc13_.trigger is HoleInRadius) || Boolean(_loc13_.trigger is Portal) || _loc13_.trigger is PortalPipe)
                     {
                        _loc14_ = BoxUtils.selectCompound(_loc8_);
                        for each(_loc15_ in _loc14_)
                        {
                           _loc16_ = _loc15_.GetLinearVelocity();
                           if(_loc16_.x > Tweak.PortalSpeedCap)
                           {
                              _loc16_.x = Tweak.PortalSpeedCap;
                           }
                           if(_loc16_.y > Tweak.PortalSpeedCap)
                           {
                              _loc16_.y = Tweak.PortalSpeedCap;
                           }
                           _loc17_ = _loc12_.GetPosition();
                           if(_loc14_.length > 1)
                           {
                              _loc17_ = new b2Vec2(_loc12_.GetPosition().x - (param1.GetPosition().x - _loc15_.GetPosition().x),_loc12_.GetPosition().y - (param1.GetPosition().y - _loc15_.GetPosition().y));
                           }
                           _loc15_.SetXForm(_loc17_,_loc15_.GetAngle());
                           _loc15_.SetLinearVelocity(_loc16_);
                        }
                        if(_loc13_.trigger is HoleInRadius)
                        {
                           HoleInRadius(_loc13_.trigger).visualOnly = true;
                           _loc13_.triggerState = -1;
                           _loc13_.triggered = true;
                        }
                        return;
                     }
                  }
               }
               _loc11_.dead = true;
            }
         }
      }
   }
}

