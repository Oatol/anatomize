package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class SenzuBean extends Trigger
   {
      
      internal var healBody:b2Body;
      
      public function SenzuBean()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Vector.<MyLittleParticle> = null;
         var _loc15_:MyLittleParticle = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:String = null;
         super.trigger(param1,param2);
         if(!this.healBody)
         {
            return;
         }
         var _loc3_:Array = BoxUtils.selectCompound(this.healBody,false);
         Body.Destroy(param1,"trigger");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_.alive)
            {
               _loc5_.bleeding = [];
               _loc5_.maxhealth = 90001;
               _loc5_.health = _loc5_.maxhealth;
               Body.Dispel(_loc4_);
               _loc6_ = BoxUtils.getEffectBMD(_loc4_);
               if(_loc6_)
               {
                  _loc6_.fillRect(_loc6_.rect,0);
               }
               if(_loc5_.name == "doll_head")
               {
                  _loc8_ = 0;
                  while(_loc8_ < 50)
                  {
                     _loc9_ = Math.random() * _loc5_.width * 1.5 - _loc5_.width - 0.75;
                     _loc10_ = Math.random() * _loc5_.height * -1.25;
                     _loc11_ = _loc4_.GetPosition().x * Physics.scale + _loc9_ * Math.cos(_loc4_.GetAngle()) - _loc10_ * Math.sin(_loc4_.GetAngle());
                     _loc12_ = _loc4_.GetPosition().y * Physics.scale + _loc9_ * Math.sin(_loc4_.GetAngle()) + _loc10_ * Math.cos(_loc4_.GetAngle());
                     _loc13_ = new b2Vec2();
                     _loc13_.y = Math.random() * -19 - 1;
                     _loc13_.x = (_loc4_.GetPosition().x * Physics.scale - _loc11_) * (-_loc13_.y / 20) * 0.1;
                     _loc13_ = BoxUtils.rotateVec(_loc13_,_loc4_.GetAngle());
                     _loc14_ = GameState.particles.addParticles(_loc11_,_loc12_,1,"shinysliver",_loc13_.x,_loc13_.y);
                     for each(_loc15_ in _loc14_)
                     {
                        _loc15_.friction = 0.8;
                        _loc15_.fade = 1;
                        _loc15_.health = 180;
                        _loc15_.wander = 1;
                     }
                     _loc8_++;
                  }
               }
               _loc7_ = 0;
               while(_loc7_ < 6)
               {
                  _loc9_ = Math.random() * _loc5_.width - _loc5_.width * 0.5;
                  _loc10_ = Math.random() * _loc5_.height - _loc5_.height * 0.5;
                  _loc11_ = _loc4_.GetPosition().x * Physics.scale + _loc9_ * Math.cos(_loc4_.GetAngle()) - _loc10_ * Math.sin(_loc4_.GetAngle());
                  _loc12_ = _loc4_.GetPosition().y * Physics.scale + _loc9_ * Math.sin(_loc4_.GetAngle()) + _loc10_ * Math.cos(_loc4_.GetAngle());
                  _loc16_ = _loc4_.GetLinearVelocity().x * 0.1;
                  _loc17_ = _loc4_.GetLinearVelocity().y * 0.1;
                  _loc18_ = "heal";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc18_ = param2.pfx.getParticle();
                  }
                  GameState.particles.addParticles(_loc11_,_loc12_,1,_loc18_,_loc16_,_loc17_);
                  _loc7_++;
               }
            }
         }
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
            return true;
         }
         this.healBody = param1;
         ud.triggered = true;
         return true;
      }
   }
}

