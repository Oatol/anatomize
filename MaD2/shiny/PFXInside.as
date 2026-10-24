package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXInside extends ParticleEffect
   {
      
      internal var popos:Vector.<b2Vec2>;
      
      public function PFXInside(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         initHull();
         applyOffset = false;
         this.popos = new Vector.<b2Vec2>();
         var _loc1_:int = 0;
         var _loc2_:Number = body.GetPosition().x;
         var _loc3_:Number = body.GetPosition().y;
         while(this.popos.length < 50)
         {
            _loc4_ = (Math.random() * body.GetUserData().width - body.GetUserData().width * 0.5) / Physics.scale;
            _loc5_ = (Math.random() * body.GetUserData().height - body.GetUserData().height * 0.5) / Physics.scale;
            _loc6_ = new b2Vec2(_loc4_,_loc5_);
            _loc6_ = BoxUtils.rotateVec(_loc6_,body.GetAngle());
            while(!Body.GetOne(_loc6_.x + _loc2_,_loc6_.y + _loc3_) && _loc1_ < 1000)
            {
               _loc4_ = (Math.random() * body.GetUserData().width - body.GetUserData().width * 0.5) / Physics.scale;
               _loc5_ = (Math.random() * body.GetUserData().height - body.GetUserData().height * 0.5) / Physics.scale;
               _loc6_ = new b2Vec2(_loc4_,_loc5_);
               _loc6_ = BoxUtils.rotateVec(_loc6_,body.GetAngle());
               _loc1_++;
            }
            this.popos.push(new b2Vec2(_loc4_,_loc5_));
         }
      }
      
      override public function update() : void
      {
         super.update();
         if(!body.GetUserData() || !body.GetUserData().hull)
         {
            return;
         }
         var _loc1_:b2Vec2 = this.popos[Math.random() * 50 >> 0];
         _loc1_ = BoxUtils.rotateVec(_loc1_,body.GetAngle());
         var _loc2_:b2Vec2 = body.GetPosition();
         addParticles((_loc1_.x + _loc2_.x) * Physics.scale,(_loc1_.y + _loc2_.y) * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

