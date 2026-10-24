package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SandPile extends Trigger
   {
      
      internal var spawned:Boolean = false;
      
      public function SandPile()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,50 * param2.size,50 * param2.size);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if((Boolean(_loc5_)) && Boolean(_loc5_.name.indexOf("shovel") != -1) && _loc4_.GetLinearVelocity().Length() > 10)
            {
               _loc6_ = new b2Vec2(0,50 * _loc5_.size);
               _loc7_ = BoxUtils.rotateVec(_loc6_,_loc4_.GetAngle());
               _loc8_ = new b2Vec2(_loc4_.GetPosition().x * Physics.scale + _loc7_.x,_loc4_.GetPosition().y * Physics.scale + _loc7_.y);
               GameState.particles.addParticles(_loc8_.x + Math.random() * 20 - 10,_loc8_.y + Math.random() * 20 - 10,1,"dust",_loc4_.GetLinearVelocity().x * 0.25,_loc4_.GetLinearVelocity().y * 0.25,1,1);
               GameState.particles.addParticles(_loc8_.x + Math.random() * 20 - 10,_loc8_.y + Math.random() * 20 - 10,1,"tinydust",_loc4_.GetLinearVelocity().x * 0.25,_loc4_.GetLinearVelocity().y * 0.25,1,1);
               if(!this.spawned && Math.random() > 0.999)
               {
                  this.spawned = true;
                  _loc9_ = GameState.objects.delayedSpawnObject("speakermalware",pixelCenter.x,pixelCenter.y,bodyAngle,false,true);
               }
               else if(Math.random() > 0.999)
               {
                  _loc9_ = GameState.objects.veryDelayedSpawnObject("goldpile",pixelCenter.x,pixelCenter.y,bodyAngle,false,true);
               }
               else if(Math.random() > 0.999)
               {
                  _loc9_ = GameState.objects.veryDelayedSpawnObject("goldpilesmall",pixelCenter.x,pixelCenter.y,bodyAngle,false,true);
               }
               else if(Math.random() > 0.999)
               {
                  _loc9_ = GameState.objects.veryDelayedSpawnObject("goldbar",pixelCenter.x,pixelCenter.y,bodyAngle,false,true);
               }
               else if(Math.random() > 0.999)
               {
                  _loc9_ = GameState.objects.veryDelayedSpawnObject("pegleg",pixelCenter.x,pixelCenter.y,bodyAngle + 90,false,true);
               }
               if(_loc9_)
               {
                  userData(_loc9_.GetUserData()).ignore = "sandpile";
                  _loc9_.ApplyImpulse(new b2Vec2(_loc4_.GetLinearVelocity().x * 0.1,_loc4_.GetLinearVelocity().y * 0.1),_loc9_.GetWorldCenter());
               }
               break;
            }
         }
      }
   }
}

