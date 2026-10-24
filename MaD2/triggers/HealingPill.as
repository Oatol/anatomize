package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class HealingPill extends Trigger
   {
      
      public function HealingPill()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         Body.Destroy(param1,"trigger");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_.alive)
            {
               _loc5_.bleeding = [];
               _loc5_.health = _loc5_.maxhealth;
               Body.Dispel(_loc4_);
               _loc6_ = BoxUtils.getEffectBMD(_loc4_);
               if(_loc6_)
               {
                  _loc6_.fillRect(_loc6_.rect,0);
               }
               _loc7_ = 0;
               while(_loc7_ < 6)
               {
                  _loc8_ = Math.random() * _loc5_.width - _loc5_.width * 0.5;
                  _loc9_ = Math.random() * _loc5_.height - _loc5_.height * 0.5;
                  _loc10_ = _loc4_.GetPosition().x * Physics.scale + _loc8_ * Math.cos(_loc4_.GetAngle()) - _loc9_ * Math.sin(_loc4_.GetAngle());
                  _loc11_ = _loc4_.GetPosition().y * Physics.scale + _loc8_ * Math.sin(_loc4_.GetAngle()) + _loc9_ * Math.cos(_loc4_.GetAngle());
                  _loc12_ = _loc4_.GetLinearVelocity().x * 0.1;
                  _loc13_ = _loc4_.GetLinearVelocity().y * 0.1;
                  _loc14_ = "heal";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc14_ = param2.pfx.getParticle();
                  }
                  GameState.particles.addParticles(_loc10_,_loc11_,1,_loc14_,_loc12_,_loc13_);
                  _loc7_++;
               }
            }
         }
         param2.dead = true;
         Body.Disintegrate(param1,"heal",50,5,5);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            return true;
         }
         ud.triggered = true;
         return true;
      }
   }
}

