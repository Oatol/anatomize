package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Glue extends GenericBullet
   {
      
      public function Glue()
      {
         super("gas");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc9_:b2Vec2 = null;
         var _loc10_:Sprite = null;
         var _loc11_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         var _loc7_:userData = userData(param1.GetUserData());
         if(!param1.IsStatic())
         {
            _loc7_.sticky = true;
            sounds.play("drain4",body,pixelCenter,0.3);
         }
         var _loc8_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc8_)
         {
            _loc9_ = param1.GetLocalPoint(param5).Copy();
            _loc10_ = new Sprite();
            _loc11_ = 0;
            while(_loc11_ < 4)
            {
               _loc10_.graphics.beginFill(14540253,Math.random() * 0.2 + 0.1);
               _loc10_.graphics.drawCircle(_loc9_.x * Physics.scale + _loc8_.width * 0.5 + (Math.random() * 4 * _loc11_ - 2 * _loc11_) * ud.size,_loc9_.y * Physics.scale + _loc8_.height * 0.5 + (Math.random() * 4 * _loc11_ - 2 * _loc11_) * ud.size,Math.random() * 4 + 1);
               _loc11_++;
            }
            _loc8_.draw(_loc10_);
         }
         return true;
      }
   }
}

