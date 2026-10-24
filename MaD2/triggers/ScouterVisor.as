package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ScouterVisor extends ArmourHelmet
   {
      
      private var tf:TextField;
      
      public function ScouterVisor(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
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
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         super.trigger(param1,param2);
         ud.triggered = true;
         var _loc3_:Array = Body.GetAround(param1,ud.triggerRadius,ud.triggerRadius);
         for each(_loc4_ in _loc3_)
         {
            if(!userData(_loc4_.GetUserData()).alive)
            {
               _loc5_ = userData(_loc4_.GetUserData());
               this.tf.textColor = 16777215;
               _loc6_ = 0;
               _loc7_ = 0;
               while(_loc7_ < _loc5_.name.length)
               {
                  _loc6_ += _loc5_.name.charCodeAt(_loc7_);
                  _loc7_++;
               }
               if(_loc5_.name == "stapler" || _loc5_.name == "senzubean")
               {
                  _loc6_ += 8500;
               }
               if(Math.random() > 0.8)
               {
                  _loc6_ = int(_loc6_ + Math.random() * 50 - 25);
               }
               this.tf.text = _loc6_.toString();
               this.tf.x = GraphicUtils.camX(_loc4_.GetPosition().x * Physics.scale) - 100 + camPos.x;
               this.tf.y = GraphicUtils.camY(_loc4_.GetPosition().y * Physics.scale) - 30 + camPos.y;
               Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomSlopeParticles("forcefield",pixelCenter,new b2Vec2(_loc4_.GetPosition().x * Physics.scale,_loc4_.GetPosition().y * Physics.scale),10,1,-0.05);
               }
               break;
            }
         }
      }
   }
}

