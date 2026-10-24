package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Paint extends Trigger
   {
      
      protected var kill:Boolean = true;
      
      public function Paint()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:String = param2.name;
         GameState.particles.addSimpleParticles(pixelCenter.x,pixelCenter.y,1,uint("0xFF" + _loc3_),bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Vec2 = null;
         var _loc9_:Sprite = null;
         var _loc10_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(this.kill)
         {
            if(param1.IsStatic() || Math.random() > 0.9)
            {
               ud.dead = true;
            }
         }
         sounds.play("drain2",body,pixelCenter,0.2);
         if(ud.name == "ffffff")
         {
            ud.name = "fffffd";
         }
         if(_loc7_)
         {
            _loc8_ = param1.GetLocalPoint(param5).Copy();
            _loc9_ = new Sprite();
            _loc10_ = 0;
            while(_loc10_ < 20 * ud.size)
            {
               _loc9_.graphics.beginFill(uint("0xFF" + ud.name),Math.random() * 0.4 + 0.2);
               _loc9_.graphics.drawCircle(_loc8_.x * Physics.scale + _loc7_.width * 0.5 + (Math.random() * 2 * _loc10_ - _loc10_) * ud.size,_loc8_.y * Physics.scale + _loc7_.height * 0.5 + (Math.random() * 2 * _loc10_ - _loc10_) * ud.size,(Math.random() * 4 + 1) * ud.size);
               _loc10_++;
            }
            _loc7_.draw(_loc9_);
         }
         return true;
      }
   }
}

