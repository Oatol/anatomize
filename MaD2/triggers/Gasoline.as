package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Gasoline extends GenericBullet
   {
      
      protected var effectColour:uint = 8350208;
      
      public function Gasoline(param1:String = "gasoline", param2:uint = 8350208)
      {
         super(param1);
         this.effectColour = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         param1.GetLinearVelocity().Multiply(0.9999);
         if(param2.burning)
         {
            param2.name = "burninggasoline";
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"fire2",bodyVel.x * 0.1,bodyVel.y * 0.1,bodyVel.x * 0.01,bodyVel.y * 0.01);
            if(Math.random() > 0.975)
            {
               _loc3_ = Body.GetAround(param1,100,100,false);
               for each(_loc4_ in _loc3_)
               {
                  _loc5_ = userData(_loc4_.GetUserData());
                  if(_loc5_.name == "gascan")
                  {
                     ++_loc5_.temperature;
                  }
                  if(_loc5_.name == "gasoline")
                  {
                     _loc5_.name = "burninggasoline";
                     _loc5_.temperature = _loc5_.ignition + 1;
                  }
               }
            }
            if(Math.random() > 0.99)
            {
               needsExploding = true;
            }
         }
         else if(bodyVel.Length() < 0.01)
         {
            needsExploding = true;
         }
         if(Math.random() > 0.999)
         {
            needsExploding = true;
         }
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         ud.dead = true;
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
         if(bodyVel.Length() < 0.01)
         {
            needsExploding = true;
            return false;
         }
         if(ud.burning)
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.name == "gasoline")
         {
            return false;
         }
         if(_loc7_.burning)
         {
            ud.temperature = _loc7_.ignition + 1;
         }
         if(!param1.IsStatic() && _loc7_.name != "wall")
         {
            _loc7_.conductivity = 0.01;
            _loc7_.ignition = 40;
            sounds.play("drain4",body,pixelCenter,0.2);
            needsExploding = true;
         }
         var _loc8_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc8_)
         {
            _loc9_ = param1.GetLocalPoint(param5).Copy();
            _loc10_ = new Sprite();
            _loc11_ = 0;
            while(_loc11_ < 10)
            {
               _loc10_.graphics.beginFill(this.effectColour,Math.random() * 0.1 + 0.05);
               _loc10_.graphics.drawCircle(_loc9_.x * Physics.scale + _loc8_.width * 0.5 + (Math.random() * 4 * _loc11_ - 2 * _loc11_) * ud.size,_loc9_.y * Physics.scale + _loc8_.height * 0.5 + (Math.random() * 4 * _loc11_ - 2 * _loc11_) * ud.size,(Math.random() * 8 + 2) * ud.size);
               _loc11_++;
            }
            _loc8_.draw(_loc10_);
         }
         return true;
      }
   }
}

