package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class PaintBrush extends Trigger
   {
      
      public var minSize:Number = 2;
      
      public var maxSize:Number = 6;
      
      protected var pcolour:uint;
      
      public function PaintBrush()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Vec2 = null;
         var _loc9_:userData = null;
         var _loc10_:Sprite = null;
         var _loc11_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!this.pcolour)
         {
            if(Boolean(ud) && Boolean(ud.skin) && ud.skin.length > 0)
            {
               this.pcolour = BoxUtils.getSkinColour(ud.skin,ud.triggerColour);
            }
            else
            {
               this.pcolour = uint("0x" + ud.triggerColour);
            }
         }
         var _loc7_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc7_)
         {
            _loc8_ = param1.GetLocalPoint(param5).Copy();
            _loc9_ = userData(param1.GetUserData());
            _loc8_.Multiply(Physics.scale);
            _loc8_.x -= Bitmap(_loc9_.graphic.getChildByName("effects")).x;
            _loc8_.y -= Bitmap(_loc9_.graphic.getChildByName("effects")).y;
            _loc10_ = new Sprite();
            _loc11_ = 0;
            while(_loc11_ < 4 * ud.size)
            {
               _loc10_.graphics.beginFill(this.pcolour,Math.random() * 0.4 + 0.2);
               _loc10_.graphics.drawCircle(_loc8_.x + (Math.random() * 2 * _loc11_ - _loc11_) * ud.size,_loc8_.y + (Math.random() * 2 * _loc11_ - _loc11_) * ud.size,(Math.random() * this.maxSize + this.minSize) * ud.size);
               _loc11_++;
            }
            _loc7_.draw(_loc10_);
         }
         return true;
      }
   }
}

