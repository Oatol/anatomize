package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GateChipNOT extends GateLogic
   {
      
      public function GateChipNOT()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:int = 0;
         super.trigger(param1,param2);
         var _loc4_:int = int(param2.connected.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = userData(param2.connected[_loc5_].GetUserData());
            if(_loc3_.trigger is GateLogic)
            {
               output = !GateLogic(_loc3_.trigger).output;
               break;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = userData(param2.connected[_loc5_].GetUserData());
            if(!(_loc3_.trigger is GateLogic))
            {
               _loc3_.triggered = output;
            }
            _loc5_++;
         }
         if(output)
         {
            Effect();
         }
         this.ConnectedEffect();
      }
      
      override protected function ConnectedEffect() : void
      {
         var _loc1_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Vector.<MyLittleParticle> = null;
         var _loc14_:MyLittleParticle = null;
         var _loc2_:String = "shock2";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc2_ = ud.pfx.getParticle();
         }
         var _loc3_:int = int(ud.connected.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = userData(ud.connected[_loc4_].GetUserData());
            if(_loc1_.trigger is GateLogic)
            {
               if(!GateLogic(_loc1_.trigger).output)
               {
                  _loc5_ = ud.connected[_loc4_];
                  _loc6_ = _loc5_.GetAngle();
                  _loc7_ = (Math.random() * _loc1_.width - _loc1_.width * 0.5) / Physics.scale;
                  _loc8_ = (Math.random() * _loc1_.height - _loc1_.height * 0.5) / Physics.scale;
                  _loc9_ = (_loc5_.GetWorldCenter().x + _loc7_ * Math.cos(_loc6_) - _loc8_ * Math.sin(_loc6_)) * Physics.scale;
                  _loc10_ = (_loc5_.GetWorldCenter().y + _loc7_ * Math.sin(_loc6_) + _loc8_ * Math.cos(_loc6_)) * Physics.scale;
                  _loc11_ = (-_loc9_ + bodyCenter.x * Physics.scale) * 0.1;
                  _loc12_ = (-_loc10_ + bodyCenter.y * Physics.scale) * 0.1;
                  _loc13_ = GameState.particles.addParticles(_loc9_,_loc10_,1,_loc2_,_loc11_,_loc12_);
                  if(_loc13_)
                  {
                     for each(_loc14_ in _loc13_)
                     {
                        _loc14_.friction = 0.9;
                        _loc14_.fade = 1;
                        _loc14_.health = 10;
                     }
                  }
               }
            }
            _loc4_++;
         }
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         output = true;
      }
      
      override public function onUntrigger() : void
      {
         output = false;
         ud._triggered = true;
      }
   }
}

