package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class HotPlate extends Trigger
   {
      
      protected var particles:Array = ["smoke","fire2","fire3","fire3"];
      
      protected var burnColour:uint = 3351074;
      
      public function HotPlate()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!ud.triggerForce)
         {
            ud.triggerForce = 8;
         }
         _loc7_.temperature += ud.triggerForce * TimeLord.speed;
         if(_loc7_.alive)
         {
            Body.Damage(param1,Math.random() * ud.triggerForce * 5 + 2,param5,new b2Vec2(),new b2Vec2(),false);
            this.Effect(param1,param5);
         }
         sounds.play("hiss",body,param5,Math.random() * 0.5);
         return true;
      }
      
      private function Effect(param1:b2Body, param2:b2Vec2) : *
      {
         var _loc9_:b2Vec2 = null;
         var _loc10_:String = null;
         var _loc3_:userData = param1.GetUserData() as userData;
         var _loc4_:b2Vec2 = param1.GetPosition();
         if(World.toggleGore == 0)
         {
            return;
         }
         var _loc5_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:Sprite = new Sprite();
         var _loc7_:int = Math.random() * 5 + 1;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = param1.GetLocalPoint(param2).Copy();
            _loc9_.Multiply(Physics.scale);
            _loc9_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
            _loc9_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
            _loc9_.x += Math.random() * 10 - 5;
            _loc9_.y += Math.random() * 10 - 5;
            if(Math.random() > 0.3)
            {
               _loc6_.graphics.beginFill(this.burnColour,0.2 * Math.random());
            }
            else
            {
               _loc6_.graphics.beginFill(_loc3_.bloodColour,0.2 * Math.random());
            }
            _loc6_.graphics.drawCircle(_loc9_.x,_loc9_.y,Math.random() * 5);
            _loc6_.graphics.endFill();
            _loc5_.draw(_loc6_);
            _loc9_.x -= _loc3_.width * 0.5;
            _loc9_.y -= _loc3_.height * 0.5;
            _loc10_ = this.particles[Math.random() * this.particles.length >> 0];
            if(Boolean(ud) && Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc10_ = ud.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc4_.x * Physics.scale + _loc9_.x,_loc4_.y * Physics.scale + _loc9_.y,1,_loc10_,0,0,2,2);
            _loc8_++;
         }
      }
   }
}

