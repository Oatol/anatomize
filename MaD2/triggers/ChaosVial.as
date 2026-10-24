package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import environment.Environment;
   
   public class ChaosVial extends Trigger
   {
      
      public function ChaosVial()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:b2Body = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:String = "darkness";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         param2.dead = true;
         Body.Disintegrate(param1,_loc3_,25,5,5);
         sounds.play("bfg",param1,pixelCenter,0.5);
         var _loc4_:Environment = GameState.environment;
         var _loc5_:int = 0;
         while(_loc5_ < Math.random() * 14 + 6)
         {
            _loc6_ = Vars.objSize;
            Vars.objSize = Math.random() * 1.6 + 0.4;
            _loc7_ = GameState.objects.spawnObject("darknesstear",0,0,0,false,true);
            if(_loc7_)
            {
               _loc8_ = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,param2.triggerRadius / Physics.scale * Math.random(),Math.random() * 360);
               _loc9_ = 0;
               while(_loc8_.x * Physics.scale < _loc4_.borderLeft || _loc8_.x * Physics.scale > _loc4_.borderRight || (_loc8_.y * Physics.scale < -_loc4_.borderTop + GameState.height || _loc8_.y * Physics.scale > GameState.height))
               {
                  _loc8_ = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,param2.triggerRadius / Physics.scale * Math.random(),Math.random() * 360);
                  if(++_loc9_ > 10)
                  {
                     _loc8_ = bodyCenter.Copy();
                     break;
                  }
               }
               _loc7_.SetXForm(_loc8_,Math.random() * Vars.PI * 2);
               userData(_loc7_.GetUserData()).triggerDuration = Math.random() * 40 + 10;
               userData(_loc7_.GetUserData()).triggerRadius = Math.random() * 150 + 50;
               userData(_loc7_.GetUserData()).triggerForce = Math.random() * 50 + 50;
               _loc7_.ApplyForce(new b2Vec2(Math.random() * 100 - 50,Math.random() * 100 - 50),_loc7_.GetPosition());
            }
            Vars.objSize = _loc6_;
            _loc5_++;
         }
      }
   }
}

