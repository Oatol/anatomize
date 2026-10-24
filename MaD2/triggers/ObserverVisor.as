package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ObserverVisor extends ArmourHelmet
   {
      
      private var tf:TextField;
      
      public function ObserverVisor(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
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
         super.trigger(param1,param2);
         ud.triggered = true;
         var _loc3_:Array = Body.GetAround(param1,ud.triggerRadius,ud.triggerRadius);
         for each(_loc4_ in _loc3_)
         {
            if(!userData(_loc4_.GetUserData()).alive)
            {
               if(ud.ignored.indexOf(_loc4_) == -1)
               {
                  _loc5_ = userData(_loc4_.GetUserData());
                  this.tf.textColor = 16777215;
                  this.tf.text = GeneralUtils.objectToName(_loc5_.name);
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
}

