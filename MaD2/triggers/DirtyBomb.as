package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DirtyBomb extends Trigger
   {
      
      public function DirtyBomb()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         param2.dead = true;
         Body.Disintegrate(param1,"radioactive",20,20,20);
         sounds.play("explosion",param1,pixelCenter,0.8);
         sounds.play("acidburn",param1,pixelCenter);
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc3_ = pixelCenter.Copy();
            _loc3_.x += Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5;
            _loc3_.y += Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5;
            _loc5_ = Vars.objDensity;
            Vars.objDensity = 0;
            _loc6_ = GameState.objects.delayedSpawnObject("portal2",_loc3_.x,_loc3_.y,0,false,true);
            Vars.objDensity = _loc5_;
            if(_loc6_)
            {
               _loc7_ = userData(_loc6_.GetUserData());
               _loc7_.trigger = new Radioactive(false);
               _loc7_.name = "radioactivetrace";
               _loc7_.ignore = "radioactivebarrel";
               _loc7_.triggerRadius = triggerRadius * 0.5;
               _loc7_.triggered = true;
               _loc7_.zerograv = true;
               _loc7_.graphic.alpha = 0;
               _loc7_.saveable = false;
               _loc7_.ghost = true;
            }
            _loc4_++;
         }
         World.explode("functionality",pixelCenter,param2.triggerForce,param2.triggerRadius,false,0);
      }
   }
}

