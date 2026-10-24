package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EarthGoblet extends Trigger
   {
      
      internal var jetW:Number;
      
      internal var jetH:Number;
      
      internal var jetY:Number;
      
      public function EarthGoblet(param1:Number = 10, param2:Number = 144, param3:Number = 20)
      {
         super();
         this.jetW = param1;
         this.jetH = param2;
         this.jetY = param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:b2Body = null;
         var _loc13_:userData = null;
         var _loc14_:BitmapData = null;
         var _loc15_:BitmapData = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc8_ = BoxUtils.rotateVec(new b2Vec2((Math.random() * this.jetW - this.jetW * 0.5) * param2.size,-this.jetY * param2.size),bodyAngle);
            _loc9_ = BoxUtils.rotateVec(new b2Vec2(0,-this.jetH * param2.size),bodyAngle);
            _loc5_ = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
            _loc6_ = new b2Vec2(_loc3_ + _loc9_.x,_loc4_ + _loc9_.y);
            _loc10_ = "petrify";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc10_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc10_,(-_loc5_.x + _loc6_.x) * 0.2,(-_loc5_.y + _loc6_.y) * 0.2,0,0);
            _loc7_++;
         }
         if(triggerDuration <= 0)
         {
            _loc11_ = GameState.cutter.CustomRaycast(_loc5_,100 * param2.size,_loc6_,false);
            _loc12_ = _loc11_[0];
            if((Boolean(_loc12_)) && !_loc12_.IsStatic())
            {
               if(_loc12_ == param1)
               {
                  return;
               }
               _loc13_ = userData(_loc12_.GetUserData());
               if(!(_loc13_.trigger is Concussion))
               {
                  Body.Freeze(_loc12_,_loc13_.temperature);
                  _loc13_.trigger = new Concussion(-1,false);
                  _loc13_.trigger.init(_loc12_,_loc13_);
               }
               _loc14_ = BoxUtils.getEffectBMD(_loc12_);
               if(_loc14_)
               {
                  _loc14_.colorTransform(_loc14_.rect,new ColorTransform(1,1,1,0.7));
                  _loc15_ = _loc14_.clone();
                  _loc16_ = Math.floor(Math.random() * 10) + 50;
                  _loc14_.copyPixels(_loc15_,_loc14_.rect,new Point(),null,null,true);
                  _loc17_ = 0;
                  while(_loc17_ < 10)
                  {
                     _loc14_.copyPixels(R.getSprite("p_petrify"),new Rectangle(0,0,8,8),new Point(-4 + Math.random() * _loc13_.width,-4 + Math.random() * _loc13_.height),null,null,true);
                     _loc17_++;
                  }
               }
               param2.triggerDuration = 4;
            }
         }
         else
         {
            --param2.triggerDuration;
         }
      }
   }
}

