package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class Blood extends Environment
   {
      
      public function Blood()
      {
         super(GameState.width,GameState.height);
         _name = "blood";
         spawnHeight = 300;
         gravity = 20;
         wind = 0;
         temperature = 40;
         _borderLeft = -2800;
         _borderRight = 2800;
         _floor = false;
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _backgroundColour = GraphicUtils.scalehex(Tweak.bloodColour,0.6);
         _wallColour = Tweak.bloodColour;
         _background = new BitmapData(1600,_height,false);
         enableParticles = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Vector.<Array> = null;
         var _loc7_:Item = null;
         var _loc10_:Number = NaN;
         var _loc11_:b2Body = null;
         super.setupBackground();
         setupBackgroundFiller(2000,GraphicUtils.scalehex(Tweak.bloodColour,0.75));
         var _loc1_:int = 0;
         while(_loc1_ < 50)
         {
            _loc10_ = GameState.width * 0.5 + Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            GameState.particles.addParticles(_loc10_,Math.random() * _height,1,"blood",0,Math.random(),0,4);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 10)
         {
            GameState.particles.systems[0].update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc2_++;
         }
         _loc4_ = _borderLeft;
         var _loc8_:Vector.<b2Body> = new Vector.<b2Body>();
         var _loc9_:Vector.<int> = new Vector.<int>();
         _loc2_ = 0;
         while(_loc2_ < 25)
         {
            _loc5_ = 700;
            _loc6_ = new Vector.<Array>();
            _loc7_ = O.getItem("blob");
            _loc6_.push(["252525",GraphicUtils.scalehex(Tweak.bloodColour,0.7 + random() * 0.1).toString(16)]);
            _loc3_ = 1.5 + random() * random() * (random() * 2.5);
            _loc4_ += _loc3_ * 80;
            if(_loc4_ > borderRight)
            {
               break;
            }
            _loc5_ -= 20 + _loc3_ * 30;
            _loc11_ = GameState.objects.spawnItem(_loc7_.vertices,[0],_loc3_,_loc7_.name,-500,-500,0,_loc7_.colours,"none",_loc6_);
            _loc11_.SetXForm(new b2Vec2(_loc4_ / Physics.scale,_loc5_ / Physics.scale),(random() * 60 - 30) * Vars.toRadians);
            _loc4_ += _loc3_ * 80;
            userData(_loc11_.GetUserData()).draining = true;
            userData(_loc11_.GetUserData()).stainless = true;
            _defaultBodies.push(_loc11_);
            _loc2_++;
         }
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         this.updateWalls();
      }
      
      override public function updateWalls() : void
      {
         var _loc1_:b2Body = null;
         super.updateWalls();
         for each(_loc1_ in _wallBodies)
         {
            userData(_loc1_.GetUserData()).draining = true;
         }
      }
      
      override public function update() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:b2Body = null;
         var _loc1_:Number = GameState.width * 0.5 + Math.random() * (Math.random() * borderRight * 2 + borderLeft);
         var _loc2_:* = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
         if(Math.random() > 0.99)
         {
            _loc3_ = new Vector.<Array>();
            _loc3_.push(["990000",GraphicUtils.scalehex(Tweak.bloodColour,0.6 + Math.random() * 0.2 - 0.1).toString(16)]);
            _loc4_ = GameState.objects.spawnObject("meatchunk",_loc1_,_loc2_,0,true,false,_loc3_);
            if(_loc4_)
            {
               userData(_loc4_.GetUserData()).triggerForce = Math.random() * 50 + 5;
            }
         }
         if(_particles)
         {
            GameState.particles.addParticles(_loc1_,_loc2_,1,"blood",0,Math.random(),0,4);
         }
         super.update();
      }
   }
}

