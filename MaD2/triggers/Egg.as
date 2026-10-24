package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Egg extends Trigger
   {
      
      internal var cols:Array;
      
      internal var projs:int;
      
      internal var rad:Number;
      
      public function Egg(param1:Array, param2:int = 20, param3:Number = 50)
      {
         super();
         this.cols = param1;
         this.projs = param2;
         this.rad = param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         var _loc5_:userData = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"functionality");
         var _loc3_:int = 0;
         while(_loc3_ < this.projs)
         {
            _loc4_ = this.cols[int(Math.random() * this.cols.length)];
            _loc5_ = Properties.objTemp(_loc4_);
            _loc6_ = Spawn.circle(pixelCenter.x + Math.random() * this.rad - this.rad * 0.5,pixelCenter.y + Math.random() * this.rad - this.rad * 0.5,1,_loc5_,[1,1,1]);
            _loc6_.SetBullet(true);
            _loc6_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc6_.ApplyImpulse(new b2Vec2((Math.random() * triggerForce - triggerForce * 0.5) * _loc6_.GetMass() * param2.size,(Math.random() * triggerForce - triggerForce * 0.5) * _loc6_.GetMass() * param2.size),_loc6_.GetPosition());
            _loc5_ = _loc6_.GetUserData();
            _loc5_.trigger = new Paint();
            _loc5_.triggered = true;
            _loc5_.projectileName = "pnt";
            _loc5_.body = _loc6_;
            _loc3_++;
         }
      }
   }
}

