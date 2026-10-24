package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CursorBullet extends GenericBullet
   {
      
      internal var targetBody:b2Body;
      
      internal var targetDir:b2Vec2;
      
      internal var welded:Boolean = false;
      
      public function CursorBullet()
      {
         trail = false;
         super("cursor");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!this.targetBody)
         {
            return;
         }
         if(!this.welded)
         {
            if(Joints.Weld("draggy",this.targetBody,param1,param1.GetPosition()))
            {
               this.welded = true;
            }
         }
         if(Math.random() > 0.8)
         {
            this.changeDir();
         }
         param1.ApplyForce(this.targetDir,param1.GetPosition());
         if(Math.random() > 0.995)
         {
            param2.dead = true;
            pepe.health = 0;
         }
         else
         {
            pepe.health = 1;
         }
      }
      
      private function changeDir() : void
      {
         var _loc1_:b2Vec2 = new b2Vec2(Math.random() * 100 - 50,Math.random() * 100 - 50);
         _loc1_.Multiply(this.targetBody.GetMass() * 20);
         this.targetDir = _loc1_;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            ud.dead = true;
            if(pepe)
            {
               pepe.health = 0;
            }
            return false;
         }
         if(this.targetBody)
         {
            return false;
         }
         this.targetBody = param1;
         this.changeDir();
         ud.triggered = true;
         ud.triggerLock = true;
         return true;
      }
   }
}

