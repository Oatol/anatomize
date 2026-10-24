package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class Turret extends Gun
   {
      
      internal var gunInstance:Firearm;
      
      internal var yspread:Number = 1;
      
      internal var rayoffsetx:Number = 0;
      
      internal var rayoffsety:Number = 0;
      
      internal var pos:b2Vec2;
      
      internal var posFlipped:b2Vec2;
      
      internal var col:uint = 11868955;
      
      internal var angle:Number = 0;
      
      public function Turret(param1:Firearm, param2:Number, param3:uint, param4:Number, param5:Number)
      {
         firearm = param1;
         this.pos = firearm.datPos;
         this.posFlipped = firearm.datPosFlipped;
         this.yspread = param2;
         this.col = param3;
         this.rayoffsetx = param4;
         this.rayoffsety = param5;
         super(param1);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Array = null;
         var _loc8_:b2Body = null;
         var _loc9_:Vector.<Array> = null;
         var _loc10_:uint = 0;
         var _loc11_:b2Vec2 = null;
         updateTriggerHelpers();
         if(param2.triggerDuration <= 0)
         {
            _loc3_ = 0;
            this.angle += TimeLord.speed * 0.1;
            if(this.angle > 15)
            {
               this.angle = -5;
            }
            if(this.angle > 5)
            {
               _loc3_ = 5 + (5 - this.angle);
            }
            else
            {
               _loc3_ = this.angle;
            }
            _loc3_ *= 0.75;
            _loc4_ = new b2Vec2(-(this.pos.x * Physics.scale - this.rayoffsetx) * param2.size * (param2.flipped ? -1 : 1),this.rayoffsety - this.pos.y * Physics.scale * param2.size);
            _loc5_ = new b2Vec2(-(this.pos.x * Physics.scale - this.rayoffsetx + 1) * param2.size * (param2.flipped ? -1 : 1),(this.rayoffsety - this.pos.y * Physics.scale + _loc3_ * (-param2.triggerDuration * 0.01)) * param2.size);
            if(triggerDuration < -3)
            {
               param2.triggerDuration += 0.1;
            }
            _loc4_ = BoxUtils.rotateVec(_loc4_,param1.GetAngle());
            _loc5_ = BoxUtils.rotateVec(_loc5_,param1.GetAngle());
            _loc6_ = param1.GetWorldCenter().Copy();
            _loc6_.Multiply(Physics.scale);
            _loc4_.Add(_loc6_);
            _loc5_.Add(_loc6_);
            _loc7_ = GameState.cutter.CustomRaycast(_loc4_,param2.triggerForce * param2.size,_loc5_,false,"turret");
            _loc8_ = _loc7_[0];
            _loc9_ = param2.skin;
            _loc10_ = this.col;
            if(Boolean(_loc9_) && _loc9_.length > 0)
            {
               _loc10_ = BoxUtils.getSkinColour(_loc9_,this.col.toString(16));
            }
            _loc11_ = new b2Vec2(Main.instance.m_sprite.x,Main.instance.m_sprite.y);
            if(_loc7_[1])
            {
               GraphicUtils.efla(Main.instance.particlesBMD,_loc4_.x + _loc11_.x,_loc4_.y + _loc11_.y,b2Vec2(_loc7_[1]).x * Physics.scale + _loc11_.x,b2Vec2(_loc7_[1]).y * Physics.scale + _loc11_.y,4278190080 + _loc10_);
            }
            else
            {
               GraphicUtils.efla(Main.instance.particlesBMD,_loc4_.x + _loc11_.x,_loc4_.y + _loc11_.y,_loc5_.x + _loc11_.x,_loc5_.y + _loc11_.y,4278190080 + _loc10_);
            }
            if(Boolean(_loc8_ && !userData(_loc8_.GetUserData()).projectile) && Boolean(!_loc8_.IsStatic()) && _loc8_ != param1)
            {
               param2.triggerDuration = Math.random() * Math.random() * Math.random() * 240 + 60 >> 0;
            }
         }
         else
         {
            firearm.datPos = new b2Vec2(this.pos.x,-this.pos.y + Math.random() * this.yspread - this.yspread * 0.5);
            firearm.datPosFlipped = new b2Vec2(this.posFlipped.x,-this.posFlipped.y + Math.random() * this.yspread - this.yspread * 0.5);
            firearm.shoot();
            param2.triggered = true;
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration == 0)
            {
               param2.triggerDuration = -20;
               param2.triggerState = Math.random() * 10 - 5;
            }
         }
      }
   }
}

