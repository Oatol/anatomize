package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Shadows
   {
      
      public static var shadowDuration:Number = -1;
      
      public static var shadowBodies:Array = [];
      
      public static var lightPos:b2Vec2 = new b2Vec2();
      
      public static var lightRadius:Number = 0;
      
      public static var shadowStrength:Number = 0.2;
      
      private static var shadows:Sprite = new Sprite();
      
      private static var lights:Sprite = new Sprite();
      
      private static var mtx:Matrix = new Matrix();
      
      public function Shadows()
      {
         super();
      }
      
      public static function drawShadows(param1:BitmapData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:b2Body = null;
         var _loc6_:Array = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:b2Vec2 = null;
         if(shadowDuration <= 0)
         {
            return;
         }
         shadows.graphics.clear();
         lights.graphics.clear();
         var _loc2_:Number = Main.instance.cam.scaleX;
         mtx.createGradientBox(lightRadius * 2 * _loc2_,lightRadius * 2 * _loc2_,0,GraphicUtils.camX(lightPos.x) - lightRadius * _loc2_,GraphicUtils.camY(lightPos.y) - lightRadius * _loc2_);
         lights.graphics.beginGradientFill(GradientType.RADIAL,[16777215,16777215],[0.2,0],[0,255],mtx);
         lights.graphics.drawCircle(GraphicUtils.camX(lightPos.x),GraphicUtils.camY(lightPos.y),lightRadius * _loc2_);
         lights.graphics.endFill();
         --shadowDuration;
         _loc3_ = new b2Vec2(lightPos.x / Physics.scale,lightPos.y / Physics.scale);
         _loc4_ = Physics.scale;
         for each(_loc5_ in shadowBodies)
         {
            if(!_loc5_.IsStatic())
            {
               if(_loc5_.GetUserData().hull)
               {
                  if(!userData(_loc5_.GetUserData()).invisible)
                  {
                     _loc6_ = userData(_loc5_.GetUserData()).hull;
                     _loc10_ = int(_loc6_.length);
                     shadows.graphics.beginFill(0,shadowStrength);
                     _loc9_ = 0;
                     while(_loc9_ < _loc10_)
                     {
                        if(_loc9_ == 0)
                        {
                           _loc7_ = new b2Vec2(_loc6_[_loc10_ - 1].x,_loc6_[_loc10_ - 1].y);
                        }
                        else
                        {
                           _loc7_ = new b2Vec2(_loc6_[_loc9_ - 1].x,_loc6_[_loc9_ - 1].y);
                        }
                        _loc8_ = new b2Vec2(_loc6_[_loc9_].x,_loc6_[_loc9_].y);
                        _loc7_.x /= _loc4_;
                        _loc7_.y /= _loc4_;
                        _loc8_.x /= _loc4_;
                        _loc8_.y /= _loc4_;
                        _loc7_ = _loc5_.GetWorldPoint(_loc7_);
                        _loc8_ = _loc5_.GetWorldPoint(_loc8_);
                        if(doesEdgeCastShadow(_loc7_,_loc8_,_loc3_))
                        {
                           shadows.graphics.moveTo(GraphicUtils.camX(_loc7_.x * _loc4_),GraphicUtils.camY(_loc7_.y * _loc4_));
                           _loc11_ = projectPoint(_loc7_,_loc3_,lightRadius * 2 / _loc4_);
                           shadows.graphics.lineTo(GraphicUtils.camX(_loc11_.x * _loc4_),GraphicUtils.camY(_loc11_.y * _loc4_));
                           _loc11_ = projectPoint(_loc8_,_loc3_,lightRadius * 2 / _loc4_);
                           shadows.graphics.lineTo(GraphicUtils.camX(_loc11_.x * _loc4_),GraphicUtils.camY(_loc11_.y * _loc4_));
                           shadows.graphics.lineTo(GraphicUtils.camX(_loc8_.x * _loc4_),GraphicUtils.camY(_loc8_.y * _loc4_));
                        }
                        _loc9_++;
                     }
                     shadows.graphics.endFill();
                  }
               }
            }
         }
         param1.draw(lights);
         param1.draw(shadows);
         param1.threshold(param1,param1.rect,new Point(),">",855638016,855638016,4294967295);
      }
      
      private static function doesEdgeCastShadow(param1:b2Vec2, param2:b2Vec2, param3:b2Vec2) : Boolean
      {
         var _loc4_:b2Vec2 = param2.Copy();
         _loc4_.Subtract(param1);
         var _loc5_:b2Vec2 = new b2Vec2(_loc4_.y,-1 * _loc4_.x);
         var _loc6_:b2Vec2 = param1.Copy();
         _loc6_.Subtract(param3);
         if(MathUtils.dotProduct(_loc5_,_loc6_) > 0)
         {
            return true;
         }
         return false;
      }
      
      private static function projectPoint(param1:b2Vec2, param2:b2Vec2, param3:Number) : b2Vec2
      {
         var _loc4_:b2Vec2 = param1.Copy();
         _loc4_.Subtract(param2);
         var _loc5_:b2Vec2 = _loc4_.Copy();
         _loc5_.Normalize();
         _loc5_.Multiply(param3);
         var _loc6_:b2Vec2 = param1.Copy();
         _loc6_.Add(_loc5_);
         return _loc6_;
      }
   }
}

