package powers
{
   import Box2D.Common.Math.b2Vec2;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class PowerTest extends Power
   {
      
      internal var firstPressPos:b2Vec2;
      
      internal var tf:TextField;
      
      public function PowerTest()
      {
         super(Tool.TEST,"forcefield");
         this.tf = new TextField();
         var _loc1_:TextFormat = this.tf.getTextFormat();
         _loc1_.size = 24;
         this.tf.defaultTextFormat = _loc1_;
         this.tf.setTextFormat(_loc1_);
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc5_:uint = 0;
         super.Press(param1,param2);
         if(!this.firstPressPos)
         {
            this.firstPressPos = pressPos.Copy();
            this.tf.x = this.firstPressPos.x + 24;
            this.tf.y = this.firstPressPos.y - 20;
         }
         var _loc3_:Number = pressPos.y - this.firstPressPos.y;
         if(Math.abs(_loc3_) > 10)
         {
            GameState.environment.temperature -= _loc3_ * 0.01;
         }
         if(GameState.environment.temperature > 200)
         {
            GameState.environment.temperature = 200;
         }
         if(GameState.environment.temperature < -200)
         {
            GameState.environment.temperature = -200;
         }
         var _loc4_:Number = GameState.environment.temperature;
         Vars.temperature = _loc4_;
         if(_loc4_ < 0)
         {
            this.tf.textColor = 65535;
         }
         else if(_loc4_ > 100)
         {
            this.tf.textColor = 16711680;
         }
         else
         {
            _loc5_ = 15658734;
            if(GraphicUtils.hexBrightness(GameState.environment.backgroundColour) > 18000)
            {
               _loc5_ = 1118481;
            }
            this.tf.textColor = _loc5_;
         }
         if(World.toggleFahrenheit == 1)
         {
            _loc4_ = 9 / 5 * _loc4_ + 32 >> 0;
         }
         GameState.menuHandler.getMenu("Environment").setValue("Temperature",_loc4_);
         this.tf.text = String(_loc4_ >> 0) + (World.toggleFahrenheit == 1 ? "°F" : "°C");
         Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
      }
      
      override public function Release() : void
      {
         super.Release();
         this.firstPressPos = null;
      }
      
      override public function Particles(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(!this.firstPressPos)
         {
            return;
         }
         var _loc3_:Number = pressPos.y - this.firstPressPos.y;
         if(_loc3_ < -10)
         {
            particle = "fire3";
         }
         else if(_loc3_ > 10)
         {
            particle = "crystal";
         }
         else
         {
            particle = "air";
         }
         var _loc4_:Vector.<MyLittleParticle> = GameState.particles.addParticles(this.firstPressPos.x,this.firstPressPos.y,1,particle,0,_loc3_ * 0.1,1,1);
         if((Boolean(_loc4_)) && Boolean(_loc4_[0]))
         {
            _loc4_[0].friction = 0.95;
         }
      }
   }
}

