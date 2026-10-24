package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class GoldenStopwatch extends Trigger
   {
      
      internal var armCounter:Number = 0;
      
      internal var bods:Vector.<b2Body> = new Vector.<b2Body>();
      
      internal var positions:Vector.<b2Vec2> = new Vector.<b2Vec2>();
      
      internal var angles:Vector.<Number> = new Vector.<Number>();
      
      internal var selfposition:b2Vec2;
      
      internal var selfangle:Number;
      
      public function GoldenStopwatch()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc10_:b2Body = null;
         super.trigger(param1,param2);
         this.armCounter -= TimeLord.speed;
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size,-4 * param2.size),bodyAngle);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(4 * param2.size,4 * param2.size),bodyAngle);
         var _loc5_:Number = 1 - this.armCounter / 360;
         var _loc6_:Sprite = new Sprite();
         var _loc7_:uint = BoxUtils.getSkinColour(param2.skin,"876a27");
         if(_loc7_ == 16711935)
         {
            _loc7_ = 8874535;
         }
         var _loc8_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,6 * param2.size,360 * (1 - _loc5_) - 90);
         _loc6_.graphics.lineStyle(3,_loc7_);
         _loc6_.graphics.moveTo(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y);
         _loc6_.graphics.lineTo(GraphicUtils.camX(pixelCenter.x) + _loc8_.x + camPos.x,GraphicUtils.camY(pixelCenter.y) + _loc8_.y + camPos.y);
         Main.instance.particlesBMD.draw(_loc6_);
         var _loc9_:Number = 1 - param2.triggerForce * 0.01;
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(this.bods.length == 0)
         {
            for each(_loc10_ in param2.connected)
            {
               this.bods.push(_loc10_);
               this.positions.push(_loc10_.GetPosition().Copy());
               this.angles.push(_loc10_.GetAngle());
            }
            this.selfposition = bodyCenter.Copy();
            this.selfangle = bodyAngle;
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc4_:int = 0;
         super.onUntrigger();
         var _loc3_:int = 0;
         while(_loc3_ < this.bods.length)
         {
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               BoxUtils.randomParticlesOnBody(this.bods[_loc3_],"portal2",1);
               _loc4_++;
            }
            this.bods[_loc3_].SetXForm(this.positions[_loc3_],this.angles[_loc3_]);
            this.bods[_loc3_].SetLinearVelocity(new b2Vec2());
            this.bods[_loc3_].SetAngularVelocity(0);
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               BoxUtils.randomParticlesOnBody(this.bods[_loc3_],"portal2",1);
               _loc4_++;
            }
            _loc3_++;
         }
         if(Boolean(this.selfposition) && Boolean(this.selfangle))
         {
            body.SetXForm(this.selfposition,this.selfangle);
         }
         this.bods = new Vector.<b2Body>();
         this.positions = new Vector.<b2Vec2>();
         this.angles = new Vector.<Number>();
      }
   }
}

