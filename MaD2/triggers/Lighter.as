package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Lighter extends Trigger
   {
      
      protected var burnbod:b2Body;
      
      protected var v1:b2Vec2;
      
      protected var v2:b2Vec2;
      
      protected var papa:String;
      
      protected var burnForce:Number = 2;
      
      protected var thawForce:Number = 6;
      
      public function Lighter(param1:b2Vec2, param2:b2Vec2, param3:String = "fire2")
      {
         super();
         this.v1 = param1;
         this.v2 = param2;
         this.papa = param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.v1.x * _loc3_,this.v1.y),bodyAngle);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.v2.x * _loc3_,this.v2.y),bodyAngle);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x * param2.size,pixelCenter.y + _loc4_.y * param2.size);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x * param2.size,pixelCenter.y + _loc5_.y * param2.size);
         var _loc8_:Array = GameState.cutter.CustomRaycast(_loc6_,Math.sqrt(BoxUtils.vectorDist(_loc6_,_loc7_)),_loc7_,true);
         if(_loc8_[0])
         {
            this.burnbod = b2Body(_loc8_[0]);
            _loc9_ = userData(this.burnbod.GetUserData());
            if(_loc9_.temperature < 0)
            {
               _loc9_.temperature += this.thawForce * param2.size;
            }
            else
            {
               _loc9_.temperature += this.burnForce * param2.size;
            }
         }
         if(Math.random() > 0.5)
         {
            this.Effect(_loc6_);
         }
      }
      
      protected function Effect(param1:b2Vec2) : void
      {
         if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
         {
            return;
         }
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            this.papa = ud.pfx.getParticle();
         }
         GameState.particles.addParticles(param1.x,param1.y,1,this.papa,bodyVel.x * 0.1,bodyVel.y * 0.1 + 1,0,0);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:b2Vec2 = ud.triggerPos.Copy();
         _loc7_.Multiply(ud.size / Physics.scale);
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(_loc7_,bodyAngle);
         _loc8_.Add(bodyCenter);
         var _loc9_:userData = userData(param1.GetUserData());
         if(_loc9_)
         {
            if(Boolean(_loc9_.triggered) && Boolean(_loc9_.trigger) && (_loc9_.trigger is Torch || _loc9_.trigger is Lighter))
            {
               ud.triggered = true;
            }
            else if(Boolean(_loc9_.trigger) && _loc9_.trigger is Bomb)
            {
               _loc9_.triggered = true;
            }
            else if(Boolean(_loc9_.trigger) && _loc9_.trigger is Firework)
            {
               _loc9_.triggered = true;
            }
            else if(Boolean(_loc9_.trigger) && _loc9_.trigger is FireworkGrenade)
            {
               _loc9_.triggered = true;
            }
            else if(_loc9_.name.substr(0,6) == "bullet")
            {
               ud.triggered = true;
               return true;
            }
         }
         return true;
      }
   }
}

