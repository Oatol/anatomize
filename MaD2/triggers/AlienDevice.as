package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class AlienDevice extends Trigger
   {
      
      internal var abducted:Vector.<b2Body>;
      
      public function AlienDevice()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:String = null;
         var _loc20_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.abs(bodyAngle) > 0.5)
         {
            return;
         }
         if(param2.triggerState == 1)
         {
            this.Abduct();
         }
         else if(param2.triggerState == 2)
         {
            if(Math.random() > 0.99)
            {
               param2.triggerState = 0;
            }
            return;
         }
         var _loc3_:b2Vec2 = bodyCenter;
         var _loc4_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc5_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc6_:Number = _loc3_.x * Physics.scale;
         var _loc7_:Number = _loc3_.y * Physics.scale;
         var _loc8_:b2Vec2 = new b2Vec2(_loc6_ - 10 * param2.size * _loc4_,_loc7_ - 10 * param2.size * _loc5_);
         var _loc9_:b2Vec2 = new b2Vec2(_loc6_ - 250 * param2.size * _loc4_,_loc7_ - 1000 * param2.size * _loc5_);
         var _loc10_:b2Vec2 = _loc8_;
         var _loc11_:b2Vec2 = _loc9_;
         var _loc12_:Number = (_loc11_.y - _loc10_.y) / (_loc11_.x - _loc10_.x);
         var _loc13_:int = 0;
         while(_loc13_ < 2)
         {
            _loc17_ = _loc10_.x + Math.random() * (_loc11_.x - _loc10_.x);
            _loc18_ = _loc10_.y + _loc12_ * (_loc17_ - _loc10_.x);
            _loc19_ = "forcefield";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc19_ = param2.pfx.getParticle();
            }
            _loc20_ = new b2Vec2(Math.random() > 0.5 ? 8 : -8,0);
            _loc20_ = BoxUtils.rotateVec(_loc20_,bodyAngle);
            GameState.particles.addParticles(_loc17_ + _loc20_.x,_loc18_ + _loc20_.y,1,_loc19_,-_loc20_.x * 0.1 * (_loc4_ + Math.PI * 0.5),-_loc20_.y * 0.1 * (_loc5_ + Math.PI * 0.5) - Math.random() * 10,0,0);
            _loc13_++;
         }
         if(param2.triggerState != 0)
         {
            return;
         }
         var _loc14_:Array = GameState.cutter.CustomRaycast(_loc8_,1000 * param2.size,_loc9_,false);
         var _loc15_:Array = [];
         var _loc16_:b2Body = _loc14_[0];
         if(_loc16_)
         {
            if(userData(_loc16_.GetUserData()).name == "wall")
            {
               if(GameState.environment.roof)
               {
                  GameState.environment.roof = false;
               }
            }
            else
            {
               if(userData(_loc16_.GetUserData()).name.indexOf("antialienhat") != -1)
               {
                  return;
               }
               _loc19_ = "forcefield";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc19_ = param2.pfx.getParticle();
               }
               userData(_loc16_.GetUserData()).trigger = new Disintegrate(_loc19_,50,5);
               userData(_loc16_.GetUserData()).triggered = true;
            }
         }
         else if(Math.random() > 0.995)
         {
            param2.triggerState = 1;
            this.abducted = new Vector.<b2Body>();
         }
      }
      
      private function Abduct() : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         var _loc7_:int = 0;
         var _loc8_:Sprite = null;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<Array> = null;
         var _loc1_:Array = Body.GetAround(body,ud.triggerRadius,ud.triggerRadius);
         var _loc2_:b2Vec2 = new b2Vec2(0,-GameState.environment.borderTop - 10);
         if(this.abducted.length == 0)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc1_.length)
            {
               _loc4_ = b2Body(_loc1_[_loc7_]);
               this.abducted.push(_loc4_);
               _loc7_++;
            }
         }
         var _loc6_:Boolean = false;
         _loc7_ = 0;
         while(_loc7_ < this.abducted.length)
         {
            _loc4_ = b2Body(this.abducted[_loc7_]);
            if(!_loc4_.GetUserData().dead)
            {
               _loc4_.WakeUp();
               _loc6_ = true;
               _loc3_ = _loc4_.GetWorldCenter().Copy();
               _loc3_.Multiply(Physics.scale);
               _loc2_.x = _loc3_.x;
               _loc8_ = new Sprite();
               _loc9_ = 501185;
               _loc10_ = ud.skin;
               if((Boolean(_loc10_)) && _loc10_.length > 0)
               {
                  _loc9_ = BoxUtils.getSkinColour(_loc10_,"07a5c1");
               }
               _loc8_.graphics.lineStyle(20,_loc9_,Math.random() * 0.1 + 0.1);
               _loc8_.graphics.beginFill(_loc9_,0.5);
               _loc8_.graphics.moveTo(GraphicUtils.camX(_loc2_.x + camPos.x),GraphicUtils.camY(_loc2_.y + camPos.y));
               _loc8_.graphics.lineTo(GraphicUtils.camX(_loc3_.x + camPos.x),GraphicUtils.camY(_loc3_.y + camPos.y));
               Main.instance.particlesBMD.draw(_loc8_);
               _loc5_ = new b2Vec2(0,-Vars.gravity - ud.triggerForce * 0.2);
               _loc5_.Multiply(_loc4_.GetMass());
               _loc4_.ApplyForce(_loc5_,_loc4_.GetWorldCenter());
            }
            _loc7_++;
         }
         if(!_loc6_)
         {
            ud.triggerState = 2;
         }
      }
   }
}

