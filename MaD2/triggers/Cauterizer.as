package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Cauterizer extends Trigger
   {
      
      public function Cauterizer()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Array = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Sprite = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:b2Vec2 = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sharp)
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return false;
         }
         for each(_loc10_ in _loc7_.bleeding)
         {
            _loc8_ = _loc10_[0] as b2Vec2;
            _loc9_ = _loc10_[1] as b2Vec2;
            _loc11_ = BoxUtils.getEffectBMD(param1);
            if(_loc11_)
            {
               _loc12_ = new Sprite();
               _loc13_ = BoxUtils.vectorDist(_loc8_,_loc9_) * Physics.scale;
               if(_loc13_ > 10)
               {
                  _loc13_ = 10;
               }
               _loc16_ = (_loc9_.y - _loc8_.y) / (_loc9_.x - _loc8_.x);
               _loc18_ = Bitmap(_loc7_.graphic.getChildByName("effects")).x;
               _loc19_ = Bitmap(_loc7_.graphic.getChildByName("effects")).y;
               _loc20_ = 0;
               while(_loc20_ < _loc13_)
               {
                  _loc12_.graphics.beginFill(3351074,Math.random() * 0.4 + 0.2);
                  _loc21_ = _loc8_.x + _loc20_ / _loc13_ * (_loc9_.x - _loc8_.x);
                  _loc22_ = _loc8_.y + _loc16_ * (_loc21_ - _loc8_.x);
                  _loc17_ = new b2Vec2(_loc21_,_loc22_);
                  _loc17_.Multiply(Physics.scale);
                  _loc17_.x -= _loc18_;
                  _loc17_.y -= _loc19_;
                  _loc12_.graphics.drawCircle(_loc17_.x,_loc17_.y,Math.random() * 3 + 1);
                  _loc12_.graphics.endFill();
                  _loc20_++;
               }
               _loc11_.draw(_loc12_);
            }
         }
         _loc7_.bleeding = [];
         return true;
      }
   }
}

