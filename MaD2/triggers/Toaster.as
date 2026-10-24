package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Toaster extends Trigger
   {
      
      internal var toastiness:Number = 0.01;
      
      internal var targetBody:b2Body;
      
      protected var aoe:Number = 16;
      
      protected var toastCol:uint = 10119505;
      
      protected var burnCol:uint = 2431251;
      
      protected var particle:String = "p_smoke";
      
      public function Toaster()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         this.Particles();
         var _loc3_:Array = Body.GetAround(param1,this.aoe,this.aoe);
         for each(_loc4_ in _loc3_)
         {
            this.Toast(_loc4_);
         }
      }
      
      protected function Particles() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         if(Math.random() > 0.95)
         {
            _loc1_ = new b2Vec2(-15 * ud.size + Math.random() * 30 * ud.size,-15 * ud.size);
            _loc2_ = BoxUtils.rotateVec(_loc1_,bodyAngle);
            _loc3_ = new b2Vec2(pixelCenter.x + _loc2_.x,pixelCenter.y + _loc2_.y);
            _loc4_ = "fire3";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc4_ = ud.pfx.getParticle();
            }
            _loc5_ = bodyAngle + Vars.PI * 0.5;
            GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,_loc4_,-2 * Math.cos(_loc5_),-2 * Math.sin(_loc5_),Math.cos(_loc5_),Math.sin(_loc5_));
         }
      }
      
      protected function Toast(param1:b2Body) : void
      {
         var _loc2_:userData = null;
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         if(!param1 || userData(param1.GetUserData()).dead)
         {
            return;
         }
         param1.WakeUp();
         ud.triggerDuration -= TimeLord.speed;
         if(triggerDuration <= 0)
         {
            this.toastiness += triggerForce * 0.001;
            ud.triggerDuration = ud.originalTriggerDuration;
            if(this.toastiness >= 1)
            {
               this.toastiness = 0;
               return;
            }
            _loc2_ = userData(param1.GetUserData());
            if(_loc2_.alive)
            {
               Body.Damage(param1,2 * (1 + this.toastiness) * (1 + this.toastiness),null,null,null,false);
            }
            _loc3_ = BoxUtils.getEffectBMD(param1);
            if(_loc3_)
            {
               _loc4_ = _loc3_.clone();
               if(this.toastiness < 0.9)
               {
                  _loc3_.fillRect(_loc3_.rect,uint(64 * this.toastiness << 24 | this.toastCol));
                  _loc2_.temperature += 2.5;
               }
               else
               {
                  _loc4_.fillRect(_loc3_.rect,uint(64 * this.toastiness << 24 | this.burnCol));
                  _loc2_.temperature += 10;
               }
               if(_loc2_.temperature > 80)
               {
                  _loc2_.temperature = 80;
               }
               _loc4_.copyPixels(R.getSprite(this.particle),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc2_.width + 10) - 5,Math.random() * (_loc2_.height + 10) - 5),null,null,true);
               _loc3_.copyPixels(_loc4_,_loc3_.rect,new Point(),null,null,true);
            }
         }
      }
   }
}

