package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import shiny.PFXCenterEmit;
   import triggers.Chainsaw;
   import triggers.Disintegrate;
   import triggers.Jumper;
   
   public class PumpkinOffence extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var rain2:ParticleSystem;
      
      internal var spawner:Timer;
      
      internal var drones:Vector.<b2Body>;
      
      internal var pumpkins:Vector.<b2Body>;
      
      public var sword:b2Body;
      
      private var tf:TextField;
      
      private var fader:Sprite;
      
      public var drone:Sprite;
      
      internal var healthbars:int;
      
      internal var dollbars:int;
      
      internal var edgepan:int;
      
      internal var dead:Boolean = false;
      
      internal var score:Number = 0;
      
      internal var gamespeed:Number = 1;
      
      internal var init:Boolean = false;
      
      internal var targetPumpkin:int = 2;
      
      internal var skipped:Boolean = false;
      
      internal var tutorial:int = -1;
      
      internal var tutoriallines:Array = ["Hello, person.","Hello, person.","Hello, person.                       ","They are coming...","CONTROLS"];
      
      internal var lines:Array = ["GIVE THEM THE GOOD STUFF!","NO UNDEAD ALLOWED!","SAY NO TO OFFICE EQUIPMENT!","BACK IN YOUR CUBICLE!","BACK IN THE GRAVE!","GIT ON OUTTA HEER!","THESE OUR ARE PUMPKINS!","I\'M SO MAD I COULD SPIT!","GET ON BACK IN THE GROUND!","THERE\'S MORE OF \'EM\nTHAN I CAN COUNT!\nAT LEAST THREE.","IF IT BLEEDS WE CAN SAW IT!","IF IT BLEEDS WE CAN SLICE IT!","IF IT BLEEDS WE CAN DICE IT!","I NEED WINDSHIELD WIPERS!","SPLURT!","SPLORT!","SAW THEM WITH THE SAWY END!","HAPPINESS IS A SHARP CHAIN!","SMILE, AND WAIT FOR THE SLASH.","TRESPASSERS WILL BE SAWED IN HALF.","GET OUTTA HEER!","GET ON OUTTA HEER!","SLASH \'EM!","SLASHER!","SPLAT!","SPLORGLE!","WROOMWROMMWROMMMM!","WRRMRMWROMRMR!","WRMWROWMRMRW!","DING!","GOTTEM!","GOT \'EM!","GET \'EM!","GUT \'EM!","GIT \'EM!","SWING FASTER!","SAW FASTER!","DESTROY. THEM. ALL.","KILL. THEM. ALL.","SAW. THEM. ALL.","CARVE. THEM. ALL.","I\'LL CARVE YER FACE!","I\'LL CARVE YER FACE OFF!","NO SOLICITORS!","LOUD NOISES AND ANGRINESS!","HELLO. BYE."
      ,"NO MERCY!"];
      
      internal var pumpkinlost:Array = ["OH THE PUMPKINITY!","ANOTHER PUMPKIN FALLS!","SAW FASTER!","SAW BETTER!","CARVE BETTER!","CARVE FASTER!","NOOOOOOOOOOOOOOOOOOO!","THEY\'RE EATING OUR PUMPKINS!","NOT THE PUMPKINS!","WHY WON\'T SOMEBODY THINK OF THE PUMPKINS!?","THEY\'VE TAKEN ANOTHER ONE!","ANOTHER PUMPKIN GONE!","PROTECT THE PUMPKINS!","SURELY THERE\'S AN END TO THIS MADNESS?","THIS IS HOPELESS","EVERYTHING WILL BURN","WE\'RE ALL GOING TO BE PROBED!","THIS IS THE END!","SAVE THE PUMPKINS!","NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!","NOOOO! THE PUMPKINS!"];
      
      internal var deadlines:Array = ["You have failed.","You just single-handedly killed everyone.","Did you at any point try sawing better?","Did you think about swinging better?","Maybe you didn\'t fail miserably in some other universe.","I\'m sure you tried your very best.","Don\'t worry. We\'ll all just be killed.","I\'m sure they will just leave and not kill us all. Yeeeah.","Just so you know, there were only 34928539258309 undead left. You killed approximately... 0.0001% of them.","It\'s not all bad. At least we\'ll know who to blame.","I mean, I had no expectations, and you still let me down.","Great job. At killing us all.","Great job. Not.","Press [Esc] to quit.","Press [Esc] to quit.","Press [Esc] to quit.","Press [Esc] to quit.","Well, at least you killed\nALIENSCORE undead.","Well, at least you killed\nALIENSCORE undead.","Well, killing ALIENSCORE undead is\nbetter than nothing.","Well, killing ALIENSCORE undead is\nbetter than nothing.","You downed ALIENSCORE undead.","You downed ALIENSCORE undead."
      ,"ALIENSCORE undead went splurt.","ALIENSCORE undead went splat.","ALIENSCORE undead down, a few hundred billion left.","ALIENSCORE undead down, a few hundred billion left.","Only ALIENSCORE undead killed? Could\'ve been a million.","Only ALIENSCORE undead killed? Could\'ve been a million.","ALIENSCORE undead destroyed.\nAnd now all of us.","ALIENSCORE undead destroyed.\nAnd now all of us.","Just so you know, this game has no win condition, and I\'m being overly antagonistic to evoke an emotional response.","If only this game had a win condition and not just disappointment."];
      
      internal var pumpkincount:int = 5;
      
      public function PumpkinOffence()
      {
         Main.instance.stage.focus = null;
         Main.instance.reset(false,false);
         this.drones = new Vector.<b2Body>();
         super(GameState.width,GameState.height);
         enableClutter = false;
         enableFiller = false;
         enableParticles = false;
         enableSeed = false;
         _name = "pumpkinoffence";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _backgroundColour = 1118481;
         _wallColour = 4467736;
         spawnX = 2000;
         _background = new BitmapData(1600,600,false,2499106);
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_fireyellow"));
         this.rain2 = new ParticleSystem("rain2",_width,_height,R.getSprite("p_smoke"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 1;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 10;
         this.rain.particleHealth = 1000;
         this.rain.particleWander = 0.2;
         this.rain2.useWorldGravity = false;
         this.rain2.particleGravity = 0.5;
         this.rain2.particleFade = 1;
         this.rain2.particleFadeRandom = 10;
         this.rain2.particleHealth = 1000;
         this.rain2.particleRestitution = 0;
         this.rain2.particleFriction = 0.9;
         this.rain2.particleWander = 1;
         _particleSystems.push(this.rain);
         _particleSystems.push(this.rain2);
         _borderLeft = -2000;
         _borderRight = 3000;
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _floor = true;
         _loop = false;
         wallThickness = 16;
      }
      
      override public function setupBackground() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.setupBackground();
         _loc2_ = 0;
         while(_loc2_ < 50)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain.addParticles(1,_loc1_,Math.random() * 600,0,0,4,4);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 10)
         {
            this.rain.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 50)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc1_,Math.random() * 600,0,0,4,4);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 10)
         {
            this.rain2.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc3_++;
         }
      }
      
      public function reset() : void
      {
         if(this.spawner)
         {
            this.spawner.stop();
         }
         this.removeGraphics();
         Tweener.removeAllTweens();
         GameState.menuHandler.getMenu("Main").open();
         GameState.menuHandler.getMenu("Toolbox").open();
         World.toggleEdgePan = this.edgepan;
         World.toggleHealthbars = this.healthbars;
         World.toggleDollbars = this.dollbars;
         Main.instance.changeEnvironment("lab");
         Main.instance.reset();
         Main.instance.loadedLevel = "";
         Main.instance.currentSave = "";
      }
      
      private function removeGraphics() : void
      {
         var _loc1_:DisplayObject = Main.instance.stage.getChildByName("openworlddrone");
         var _loc2_:DisplayObject = Main.instance.stage.getChildByName("openworldtf");
         var _loc3_:DisplayObject = Main.instance.stage.getChildByName("openworldfader");
         if(_loc1_)
         {
            Main.instance.stage.removeChild(_loc1_);
         }
         if(_loc2_)
         {
            Main.instance.stage.removeChild(_loc2_);
         }
         if(_loc3_)
         {
            Main.instance.stage.removeChild(_loc3_);
         }
         sounds.stop("halloweenmusic");
      }
      
      public function Init() : *
      {
         var _loc1_:b2Body = null;
         var _loc3_:int = 0;
         this.init = true;
         Main.instance.reset(false,true);
         IO.loadWorld("mutilate=2;walls=442c18;wallR=false;wallL=false;roof=false;particles=true;camera=300,0,0.75;loop=false;filler=false;autowind=false;seed=42;clutter=100;gravity=20;wind=0;temperature=37;breakalive=1,breakjoints=1,breakobjects=1,contacts=1|NM=makeshiftpipespear,PX=254.00,PY=499.00,AN=-34.00,DN=0,TM=37,LR=0;NM=makeshiftpipespear,PX=754.00,PY=502.00,AN=40.00,DN=0,TM=37,LR=0;NM=residentialfencepost,PX=770.00,PY=526.00,AN=50.00,DN=0,TM=37,LR=0;NM=residentialfencepost,PX=231.00,PY=534.00,AN=-53.00,SZ=0.95,DN=0,TM=37,LR=0;NM=residentialfencesegment,PX=412.00,PY=536.00,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=501.00,PY=536.00,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=590.00,PY=536.00,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=323.00,PY=536.00,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=679.00,PY=536.00,DN=0,TM=37,LR=0,ghost=1;NM=woodensign,PX=111.00,PY=530.00,AN=-10.00,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencepost,PX=280.00,PY=490.00,SZ=1.1663507799970831,DN=0,TM=37,LR=0;NM=walkingplank,PX=376.00,PY=487.00,SZ=1.0526315789473681,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencepost,PX=721.00,PY=490.00,SZ=1.166350779997083,DN=0,TM=37,LR=0;NM=walkingplank,PX=544.00,PY=487.00,SZ=1.0526315789473681,DN=0,TM=37,LR=0,ghost=1,flipped=1;NM=makeshiftpipespear,PX=806.00,PY=556.00,AN=70.00,SZ=1,DN=0,TM=37,LR=0;NM=makeshiftpipespear,PX=198.00,PY=555.00,AN=-70.00,SZ=1,DN=0,TM=37,LR=0;NM=stapler,SZ=1.15,PX=118.00,PY=527.00,AN=-10.00,DN=0,TM=37,LR=0,ghost=1;NM=simplecrossalpha,SZ=0.4,PX=110.00,PY=528.00,AN=-55.00,DN=0,TM=37,LR=0,ghost=1|||ID=0,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=1,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=2,SKIN=7444334A2B20.7259513B2620;ID=3,SKIN=7444334A2B20.7259513B2620;ID=4,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=5,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=6,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=7,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=8,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=10,SKIN=744433573023.7259514B2F27;ID=11,SKIN=574531402509;ID=12,SKIN=744433573023.7259514B2F27;ID=13,SKIN=574531402509;ID=14,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=15,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=17,SKIN=777777760000;ID=9,SKIN=D6CCB62E1D02|||"
         ,true,false);
         _borderLeft = -2000;
         _borderRight = 3000;
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _floor = true;
         _loop = false;
         wallThickness = 16;
         updateWalls();
         this.edgepan = World.toggleEdgePan;
         this.healthbars = World.toggleHealthbars;
         this.dollbars = World.toggleDollbars;
         World.toggleHealthbars = 0;
         World.toggleDollbars = 0;
         World.toggleEdgePan = 0;
         Main.instance.cam.scaleX = Main.instance.cam.scaleY = 0.7;
         Main.instance.cam.x = 200;
         Main.instance.cam.y = 180;
         this.score = 0;
         Tool.drag();
         this.pumpkins = new Vector.<b2Body>();
         var _loc2_:Array = [0.75,0.9,1,0.9,0.75];
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc1_ = GameState.objects.spawnItem(O.getItem("pumpkin").vertices,[1],O.getItem("pumpkin").scale * _loc2_[_loc3_],"pumpkin",GameState.width * 0.5 - 125 + _loc3_ * 50,-580,0,O.getItem("pumpkin").colours);
            userData(_loc1_.GetUserData()).layer = 2;
            userData(_loc1_.GetUserData()).locked = true;
            userData(_loc1_.GetUserData()).alive = true;
            userData(_loc1_.GetUserData()).layer = 2;
            userData(_loc1_.GetUserData()).health = _loc2_[_loc3_] * 300;
            userData(_loc1_.GetUserData()).maxhealth = userData(_loc1_.GetUserData()).health;
            userData(_loc1_.GetUserData()).bloodColour = 16742694;
            GraphicUtils.addGraphicToLayer(_loc1_.GetUserData());
            this.pumpkins.push(_loc1_);
            _loc3_++;
         }
         var _loc4_:Number = 125;
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            this.pumpkins[_loc3_].SetXForm(new b2Vec2((GameState.width * 0.5 - _loc4_ + _loc3_ * 50) / Physics.scale,580 / Physics.scale),0);
            _loc3_++;
         }
         this.sword = GameState.objects.delayedSpawnObject("chainsaw",GameState.width * 0.5 - 50,350,0,true,true);
         userData(this.sword.GetUserData()).ignore = "pumpkin";
         userData(this.sword.GetUserData()).resistCutting = true;
         userData(this.sword.GetUserData()).trigger = new Chainsaw();
         userData(this.sword.GetUserData()).triggered = true;
         userData(this.sword.GetUserData()).sleepOnSpawn = true;
         userData(this.sword.GetUserData()).pfx = new PFXCenterEmit(this.sword,this.sword.GetWorldCenter());
         userData(this.sword.GetUserData()).pfx.attachParticles(1,"smoke");
         userData(this.sword.GetUserData()).pfx.amount = 0.1;
         this.sword.PutToSleep();
         this.tutorial = 1;
         this.drone = O.getItem("dronespeaker").updateGraphic();
         this.drone.x = 200;
         this.drone.y = 200;
         this.drone.name = "openworlddrone";
         var _loc5_:Sprite = O.getItem("wheatstraw").updateGraphic();
         _loc5_.scaleX = -1;
         _loc5_.x = 30;
         this.drone.addChild(_loc5_);
         var _loc6_:Sprite = O.getItem("theeastwood2").updateGraphic();
         _loc6_.scaleX = -1;
         _loc6_.x = 0;
         _loc6_.y = -18;
         this.drone.addChild(_loc6_);
         this.fader = new Sprite();
         this.fader.name = "openworldfader";
         this.fader.mouseEnabled = false;
         this.fader.graphics.beginFill(0);
         this.fader.graphics.drawRect(0,0,1280,720);
         var _loc7_:TextField = new TextField();
         _loc7_.name = "otf";
         _loc7_.defaultTextFormat = new TextFormat(Tweak.FONT,72);
         _loc7_.textColor = 5287527;
         _loc7_.wordWrap = true;
         _loc7_.multiline = true;
         _loc7_.selectable = false;
         _loc7_.mouseEnabled = false;
         _loc7_.width = GameState.width;
         _loc7_.height = GameState.height;
         _loc7_.text = "\nNIGHT\nOF THE\nLIVING\nSTAPLERS";
         _loc7_.y = 30;
         var _loc8_:TextFormat = _loc7_.getTextFormat();
         _loc8_.align = TextFormatAlign.CENTER;
         _loc7_.setTextFormat(_loc8_);
         this.fader.addChild(_loc7_);
         this.tf = new TextField();
         this.tf.name = "openworldtf";
         this.tf.defaultTextFormat = new TextFormat(Window.FONT,24);
         this.tf.textColor = 16777164;
         this.tf.width = 450;
         this.tf.height = 200;
         this.tf.wordWrap = true;
         this.tf.multiline = true;
         this.tf.selectable = false;
         this.tf.mouseEnabled = false;
         this.tf.text = "Hello, world.";
         var _loc9_:TextFormat = this.tf.getTextFormat();
         _loc9_.align = TextFormatAlign.CENTER;
         this.tf.setTextFormat(_loc9_);
         this.tf.filters = [new GlowFilter(1118481,1,2,2,4)];
         Main.instance.stage.addChild(this.tf);
         Main.instance.stage.addChild(this.drone);
         Main.instance.stage.addChild(this.fader);
         this.animate();
         this.animaterotate();
         this.animatetext();
         this.animatefadein();
         this.spawner = new Timer(3000);
         this.spawner.addEventListener(TimerEvent.TIMER,this.spawn);
         this.spawner.start();
      }
      
      override public function update() : void
      {
         var _loc1_:* = 0;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:b2Body = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:int = 0;
         if(_particles)
         {
            _loc3_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc4_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            if(Math.random() > 0.5)
            {
               this.rain.addParticles(1,_loc3_,_loc4_,0,0,4,4);
            }
            if(Math.random() > 0.5)
            {
               _loc3_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
               this.rain2.addParticles(1,_loc3_,_loc4_,0,0,4,4);
            }
            if(Math.random() > 0.5)
            {
               _loc3_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
               this.rain2.addParticles(1,_loc3_,_loc4_,0,0,4,4);
            }
         }
         super.update();
         if(!this.init)
         {
            this.Init();
         }
         this.tf.x += (-this.tf.x + this.drone.x + 50) * 0.01;
         this.tf.y += (-this.tf.y + this.drone.y - 25) * 0.01;
         if(this.dead)
         {
            return;
         }
         if(this.pumpkins.length == 0)
         {
            for each(_loc5_ in this.pumpkins)
            {
               Body.Disintegrate(_loc5_,"inherit",100,10,10);
            }
            this.dead = true;
            _loc6_ = "You mowed down ALIENSCORE undead before perishing. Press [Esc] to quit.";
            _loc6_ = _loc6_.replace("ALIENSCORE",this.score.toString());
            this.tf.text = _loc6_;
            _loc7_ = ["explosive","fire2","fire3","explosive","fire2","fire3","bigSmoke","smoke","shock","slice"];
            _loc8_ = 1000;
            _loc9_ = this.sword.GetWorldCenter().Copy();
            _loc9_.Multiply(Physics.scale);
            _loc10_ = 0;
            while(_loc10_ < _loc8_)
            {
               GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,_loc7_[Math.random() * _loc7_.length >> 0],0,0,Math.random() * 100,Math.random() * 100);
               _loc10_++;
            }
            Body.Disintegrate(this.sword,"fire",10000,100,100);
            return;
         }
         if(this.tutorial != 0)
         {
            if(GameState.mouseDown && !this.skipped)
            {
               Tweener.removeTweens(this.tf);
               this.animatetext();
               this.skipped = true;
            }
            else if(!GameState.mouseDown)
            {
               this.skipped = false;
            }
         }
         _loc1_ = 0;
         while(_loc1_ < this.pumpkins.length)
         {
            if(userData(this.pumpkins[_loc1_].GetUserData()).dead)
            {
               this.pumpkins.splice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.drones.length)
         {
            if(userData(this.drones[_loc1_].GetUserData()).dead)
            {
               this.drones.splice(_loc1_,1);
               _loc1_--;
               ++this.score;
            }
            _loc1_++;
         }
         var _loc2_:b2Body = Physics.world.GetBodyList();
         while(_loc2_)
         {
            if(userData(_loc2_.GetUserData()).hasBeenCut)
            {
               userData(_loc2_.GetUserData()).trigger = new Disintegrate("blood",50,10);
               userData(_loc2_.GetUserData()).triggered = true;
            }
            _loc2_ = _loc2_.GetNext();
         }
      }
      
      public function spawn(param1:TimerEvent) : void
      {
         var _loc4_:b2Body = null;
         if(this.drones.length > 30)
         {
            Body.Disintegrate(this.drones[0],"inherit",100,10,10);
            return;
         }
         var _loc2_:Vector.<Array> = new Vector.<Array>();
         _loc2_.push(["07a7c4","C19100"]);
         _loc2_.push(["b5b5b5","bb5b1b"]);
         _loc2_.push(["616161","3D2B19"]);
         _loc2_.push(["424242","202020"]);
         GameState.objects.spawnSkin = _loc2_;
         var _loc3_:Boolean = Math.random() > 0.5;
         Vars.objFriction = 999;
         Vars.objSize = Math.min(2,Math.random() * Math.random() * this.gamespeed / 100) + 0.5;
         var _loc5_:Number = Math.random() * 100;
         var _loc6_:Number = 1000;
         var _loc7_:Number = _loc3_ ? -300 - Math.random() * 500 : 1300 + Math.random() * 500;
         var _loc8_:Number = Math.random() * 550;
         if(_loc5_ > 90 && this.gamespeed > 500)
         {
            _loc7_ = 400 + Math.random() * 400;
            _loc8_ = -1000;
            _loc4_ = GameState.objects.delayedSpawnObject("barnaclestapler",_loc7_,_loc8_,0,!_loc3_,true,_loc2_);
         }
         else if(_loc5_ > 80)
         {
            _loc4_ = GameState.objects.delayedSpawnObject("feralstapler",_loc7_,_loc8_,0,!_loc3_,true,_loc2_);
            _loc6_ = 10000;
         }
         else
         {
            _loc4_ = GameState.objects.delayedSpawnObject("stapler2",_loc7_,_loc8_,0,!_loc3_,true,_loc2_);
         }
         var _loc9_:userData = userData(_loc4_.GetUserData());
         _loc9_.alive = true;
         _loc9_.ignore = "projectiles";
         _loc9_.maxhealth = _loc6_ + this.gamespeed;
         _loc9_.health = _loc9_.maxhealth;
         _loc9_.bloodColour = 5592405;
         _loc9_.draining = true;
         _loc9_.trigger = new Jumper();
         _loc9_.projectile = true;
         _loc9_.triggerForce = Math.min(200,Math.random() * 30 + 20 + this.gamespeed / 200);
         _loc9_.triggerDuration = Math.max((Math.random() * 15 + 15) / (this.gamespeed / 1000),5);
         _loc9_.triggered = true;
         Vars.objFriction = 0.1;
         Vars.objSize = 1;
         if(!_loc3_)
         {
            userData(_loc4_.GetUserData()).triggerForce = userData(_loc4_.GetUserData()).triggerForce * -1;
         }
         GameState.objects.spawnSkin = new Vector.<Array>();
         this.drones.push(_loc4_);
         this.gamespeed += 50;
         if(this.spawner.delay > 500)
         {
            this.spawner.delay -= 50;
         }
      }
      
      private function animate() : void
      {
         Tweener.addTween(this.drone,{
            "x":Math.random() * 100 + 100,
            "y":Math.random() * 100 + 100,
            "time":(0.4 + Math.random() * 0.8) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animate
         });
      }
      
      private function animaterotate() : void
      {
         Tweener.addTween(this.drone,{
            "rotation":Math.random() * 60 - 30,
            "delay":0.2 + Math.random() * 0.6,
            "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
            "transition":"easeInOutBounce",
            "onComplete":this.animaterotate
         });
      }
      
      private function animatetext() : void
      {
         var line:String = null;
         try
         {
            line = this.lines[int(Math.random() * this.lines.length)];
            if(this.pumpkincount > this.pumpkins.length)
            {
               line = this.pumpkinlost[int(Math.random() * this.pumpkinlost.length)];
               this.pumpkincount = this.pumpkins.length;
            }
            if(this.dead)
            {
               line = this.deadlines[int(Math.random() * this.deadlines.length)];
               line = line.replace("ALIENSCORE",this.score.toString());
               if(this.drones.length > 10)
               {
                  this.spawner.stop();
               }
            }
            if(this.tutorial != 0)
            {
               line = this.tutoriallines[this.tutorial];
               ++this.tutorial;
               line = line.replace("CONTROLS","Use the CHAINSAW!\nKill... Them... ALL!");
               if(this.tutorial >= this.tutoriallines.length)
               {
                  this.tutorial = 0;
               }
            }
         }
         catch(e:Error)
         {
            line = "...";
         }
         this.tf.text = line;
         this.tf.scaleX = 1;
         this.tf.scaleY = 1;
         Tweener.addTween(this.tf,{
            "scaleX":0.5,
            "scaleY":0.5,
            "delay":this.tf.text.length * 0.1 + 1,
            "time":0.2 / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animatetext
         });
      }
      
      private function animatefadeout() : void
      {
         GameState.menuHandler.closeAll();
         if(!sounds.isPlaying("halloweenmusic"))
         {
            sounds.play("halloweenmusic",null,null,2,true,9000);
         }
         Tweener.addTween(this.fader,{
            "alpha":0,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack"
         });
         this.tf.text = "";
      }
      
      private function animatefadein() : void
      {
         Tweener.addTween(this.fader,{
            "alpha":1,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animatefadeout
         });
      }
   }
}

