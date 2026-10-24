package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class SpookGrenade extends Trigger
   {
      
      public function SpookGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:BitmapData = null;
         var _loc12_:BitmapData = null;
         var _loc13_:int = 0;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration < 0)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"ghost",100,5,5);
         }
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            if(triggerState == 0)
            {
               sounds.play("flies",param1,pixelCenter,0.2);
               sounds.play("tinygrowth",param1,pixelCenter,0.5);
               _loc11_ = BoxUtils.getEffectBMD(_loc5_);
               if(_loc11_)
               {
                  _loc12_ = _loc11_.clone();
                  _loc13_ = Math.floor(Math.random() * 10) + 50;
                  _loc12_.fillRect(_loc11_.rect,uint(_loc13_ << 24 | 255 << 16 | 255 << 8 | 0xFF));
                  _loc11_.copyPixels(_loc12_,_loc11_.rect,new Point(),null,null,true);
               }
               param2.triggerState = 1;
            }
            if(!userData(_loc5_.GetUserData()).resistGust)
            {
               _loc6_ = new b2Vec2(-_loc5_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc5_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
               _loc7_ = _loc6_.Normalize();
               _loc8_ = (_loc3_ - _loc7_) / _loc3_ * -param2.triggerForce;
               _loc9_ = new b2Vec2(_loc6_.x * _loc8_,_loc6_.y * _loc8_);
               _loc5_.WakeUp();
               _loc5_.ApplyForce(_loc9_,_loc5_.GetWorldCenter());
               _loc5_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.2,bodyVel.y * 0.2));
               _loc10_ = new b2Vec2(Math.random() - 0.5,Math.random() - 0.5);
               _loc10_.Multiply(1000 * param1.GetMass());
               _loc5_.ApplyForce(_loc10_,_loc5_.GetWorldCenter());
            }
         }
         if(Math.random() > 0.9)
         {
            sounds.play("tinyhiss",param1,pixelCenter,0.6);
         }
         BoxUtils.randomParticlesOnBody(param1,"ghost",Math.random() * 6);
      }
   }
}

