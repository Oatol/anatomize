package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class LaserBeamBullet extends GenericBullet
   {
      
      internal var customs:Object;
      
      internal var killRandom:Number = 1;
      
      internal var sticky:Number = 0;
      
      internal var slow:Number = 0;
      
      internal var cutLen:Number = 10;
      
      internal var rayLen:Number = 10;
      
      internal var effects:Array;
      
      internal var offset:b2Vec2;
      
      public function LaserBeamBullet()
      {
         super("slice");
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
         this.killRandom = GeneralUtils.ObjValue(0,Number(this.customs["dieRandomly"]));
         this.sticky = GeneralUtils.ObjValue(0,Number(this.customs["follow"]));
         this.slow = GeneralUtils.ObjValue(0,Number(this.customs["slowdown"]));
         this.cutLen = GeneralUtils.ObjValue(10,Number(this.customs["cut"]));
         if(this.customs["ray"])
         {
            this.rayLen = GeneralUtils.ObjValue(10,Number(this.customs["ray"]));
         }
         else
         {
            this.rayLen = this.cutLen;
         }
         this.offset = new b2Vec2();
         if(this.customs["offset"])
         {
            this.offset = GeneralUtils.toVec(this.customs["offset"]);
            this.offset.Multiply(1 / Physics.scale);
         }
         this.effects = [];
         if(this.customs["effects"])
         {
            this.effects = this.customs["effects"].split(",");
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:userData = null;
         var _loc6_:Vector.<Array> = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:b2Body = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(this.killRandom > 0)
         {
            if(param2.triggerDuration != param2.originalTriggerDuration)
            {
               if(Math.random() > (100 - this.killRandom) * 0.01)
               {
                  param2.dead = true;
                  return;
               }
            }
         }
         if(Boolean(param2.connected) && param2.connected.length > 0)
         {
            if(triggerForce > 0)
            {
               _loc11_ = triggerForce;
               _loc12_ = new b2Vec2(Math.random() * _loc11_ - _loc11_ * 0.5,Math.random() * _loc11_ - _loc11_ * 0.5 - 2);
               _loc12_.Multiply(param1.GetMass());
               param1.ApplyForce(_loc12_,bodyCenter);
            }
            _loc3_ = this.offset.Copy();
            if(param2.connected[0].GetUserData().flipped)
            {
               _loc3_.x *= -1;
            }
            _loc4_ = param2.connected[0].GetWorldPoint(_loc3_);
            _loc4_.Multiply(Physics.scale);
            _loc5_ = userData(param2.connected[0].GetUserData());
            _loc6_ = _loc5_.skin;
            _loc7_ = BoxUtils.getSkinColour(_loc6_,_loc5_.triggerColour);
            if(_loc7_ == 16711935)
            {
               _loc7_ = uint("0x" + _loc5_.triggerColour);
            }
            GraphicUtils.efla(Main.instance.particlesBMD,pixelCenter.x + camPos.x,pixelCenter.y + camPos.y,_loc4_.x + camPos.x,_loc4_.y + camPos.y,Math.random() * 255 << 24 | _loc7_);
            GameState.cutter.ExcludeSingle(param2.connected[0]);
            _loc8_ = GameState.cutter.CustomRaycast(pixelCenter,this.rayLen,_loc4_,true);
            _loc9_ = _loc8_[0];
            if(!_loc9_)
            {
               return;
            }
            if(_loc9_ == param1)
            {
               return;
            }
            if(_loc9_ == param2.connected[0])
            {
               return;
            }
            if(param2.triggerDuration > 0)
            {
               param2.triggerDuration -= TimeLord.speed;
               if(param2.triggerDuration <= 0)
               {
                  param2.dead = true;
               }
            }
            if(param2.connected.indexOf(_loc9_) != -1)
            {
               return;
            }
            if(this.sticky != 0)
            {
               _loc13_ = _loc9_.GetPosition().Copy();
               _loc13_.Subtract(param1.GetPosition());
               _loc13_.Multiply(this.sticky * 0.01);
               param1.ApplyForce(_loc13_,bodyCenter);
            }
            if(this.slow != 0)
            {
               param1.GetLinearVelocity().Multiply(this.slow * 0.01);
            }
            for each(_loc10_ in this.effects)
            {
               Body.ApplyEffect(_loc9_,_loc10_,b2Vec2(_loc8_[1]));
            }
            if(this.cutLen > 0)
            {
               GameState.madeby = "functionality";
               GameState.cutter.CustomCut(pixelCenter,_loc4_,1,this.cutLen);
            }
         }
      }
   }
}

