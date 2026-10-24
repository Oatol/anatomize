package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Thermometer extends Trigger
   {
      
      private var tf:TextField;
      
      public function Thermometer()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.tf = new TextField();
         this.tf.width = 200;
         this.tf.height = 32;
         var _loc3_:TextFormat = new TextFormat(Tweak.FONT);
         _loc3_.align = TextFormatAlign.CENTER;
         _loc3_.size = 18;
         this.tf.defaultTextFormat = _loc3_;
         this.tf.setTextFormat(_loc3_);
         this.tf.filters = [new GlowFilter(0,1,4,4,10)];
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc12_:userData = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.flipped)
         {
            _loc3_ = new b2Vec2(-20 * param2.size,-10 * param2.size);
            _loc4_ = new b2Vec2(-30 * param2.size,-10 * param2.size);
         }
         else
         {
            _loc3_ = new b2Vec2(20 * param2.size,-10 * param2.size);
            _loc4_ = new b2Vec2(30 * param2.size,-10 * param2.size);
         }
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc8_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc9_:Array = GameState.cutter.CustomRaycast(_loc7_,triggerForce * param2.size,_loc8_,false);
         var _loc10_:b2Body = _loc9_[0];
         var _loc11_:Boolean = false;
         if(_loc9_[1])
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc7_.x + camPos.x,_loc7_.y + camPos.y,b2Vec2(_loc9_[1]).x * Physics.scale + camPos.x,b2Vec2(_loc9_[1]).y * Physics.scale + camPos.y,4294901760);
         }
         else
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc7_.x + camPos.x,_loc7_.y + camPos.y,_loc8_.x + camPos.x,_loc8_.y + camPos.y,4294901760);
         }
         if(Boolean(_loc10_) && !_loc10_.IsStatic())
         {
            _loc12_ = userData(_loc10_.GetUserData());
            _loc13_ = userData(_loc10_.GetUserData()).temperature;
            if(_loc13_ > 100 || _loc13_ < -10)
            {
               for each(_loc15_ in param2.connected)
               {
                  userData(_loc15_.GetUserData()).triggered = true;
               }
               _loc11_ = true;
            }
            if(_loc12_.burning)
            {
               this.tf.textColor = 16711680;
            }
            else if(_loc12_.temperature < 0)
            {
               this.tf.textColor = 65535;
            }
            else
            {
               this.tf.textColor = 16777215;
            }
            _loc14_ = _loc12_.temperature;
            if(World.toggleFahrenheit == 1)
            {
               _loc14_ = 9 / 5 * _loc14_ + 32;
            }
            this.tf.text = String(_loc14_ >> 0) + (World.toggleFahrenheit == 1 ? "°F" : "°C");
            this.tf.x = GraphicUtils.camX(_loc10_.GetPosition().x * Physics.scale) - 100 + camPos.x;
            this.tf.y = GraphicUtils.camY(_loc10_.GetPosition().y * Physics.scale) - 30 + camPos.y;
            Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
         }
         if(!_loc11_)
         {
            for each(_loc15_ in param2.connected)
            {
               userData(_loc15_.GetUserData()).triggered = false;
            }
         }
      }
   }
}

