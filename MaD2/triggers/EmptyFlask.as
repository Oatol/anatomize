package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class EmptyFlask extends Cauldron
   {
      
      internal var decals:Sprite;
      
      internal var redraw:Boolean = true;
      
      public function EmptyFlask()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.decals = param2.graphic.getChildByName("decals") as Sprite;
         whenToBoilOver = 11;
         maxProjectiles = 10;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.trigger(param1,param2);
         if(this.redraw)
         {
            _loc3_ = Math.min(1,elements.length / maxProjectiles);
            this.decals.scaleY = _loc3_;
            this.decals.y = (20 - 20 * this.decals.scaleY) * param2.size;
            this.redraw = false;
         }
         if(Math.random() > 0.9)
         {
            _loc4_ = bodyAngle * Vars.toDegrees;
            if(_loc4_ % 360 > 60 && _loc4_ % 360 < 300 || _loc4_ % 360 > -300 && _loc4_ % 360 < -60)
            {
               boil();
            }
         }
      }
      
      override protected function Effect() : void
      {
         super.Effect();
         this.redraw = true;
      }
   }
}

