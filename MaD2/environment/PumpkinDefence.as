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
   import triggers.Disintegrate;
   
   public class PumpkinDefence extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var rain2:ParticleSystem;
      
      internal var spawner:Timer;
      
      internal var drones:Vector.<b2Body>;
      
      internal var pumpkins:Vector.<b2Body>;
      
      public var gun:b2Body;
      
      public var gun2:b2Body;
      
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
      
      internal var tutoriallines:Array = ["Hello, person.","Hello, person.","Hello, person.                               ","I hardly know where to begin to paint for you a word picture.","There is a strange scene\nbefore my eyes. If I had eyes.","This is the most terrifying thing\nI have ever witnessed.","The horizon is on fire.","They\'re coming this way.","It is indeed a very good thing we have been preparing for years.","[INCOMING TRANSMISSION]","[/YOU/ DIRTIED \\OUR\\ IDENTITY]","[\\OUR\\ FACES CARVED]","[INTO /YOUR/ DIRTY VEGETABLES]","[IN /YOUR/ ARROGANCE\nSHALL /YOU/ BURN]","[END TRANSMISSION]","They come.","CONTROLS"];
      
      internal var lines:Array = ["GIVE THEM THE GOOD STUFF!","LET THE SHOTGUN SING!","SHOOT THE SHOOTGUN!\nI MEAN SHOTGUN!","GIT ON OUTTA HEER!","THESE OUR ARE PUMPKINS!","I\'M SO MAD I COULD SPIT!","WHERE\'S MY GUN?!","GIVE ME A GUN!","YEE-HAW!","GET ON BACK TO YER PLANET!","THERE\'S MORE OF \'EM\nTHAN I CAN COUNT!\nAT LEAST THREE.","WELCOME TO EARTH.","PULL THE BANG SWITCH!","IF IT BLEEDS WE CAN SHOOT IT!","THIS IS A POINT AND CLICK GAME!","SMEAR THE SKIES WITH BLOOD!","I NEED WINDSHIELD WIPERS!","SPLURT!","SPLORT!","SHOOT THEM WITH THE SHOOTY END!","GON SHUT THEM SAUCER MOUTHS WITH A SHOTGUN!","SAUCER? SHOOT \'EM.","BURY THEM IN THE SKIES!","THEMS UFOS DON\'T EVEN HAVE SHOTGUNS!","HAPPINESS IS A WARM GUN!","SMILE, AND WAIT FOR THE FLASH.","TRESPASSERS WILL BE SHOT.","THIS IS OUR ROCK!","GET OUTTA HEER!","GET ON OUTTA HEER!","FREE AUTOPSY WITH EVERY SHOT!","UFO MORE LIKE DOA!","SPLAT!","SPLORGLE!","BANG!","BOOM!","DING!","GOTTEM!","GOT \'EM!","GET \'EM!","GUT \'EM!","GIT \'EM!","THESE GUNS ARE TOO SLOW!"
      ,"RELOAD FASTER!","SHOOT FASTER!","POINT! AND! CLICK!","DESTROY. THEM. ALL.","KILL. THEM. ALL.","BURN. THEM. ALL.","SHOOT. THEM. ALL.","HAVE SOME ANTI-ALIEN SOFTWARE!","BULLETS ARE MADE OF BULLETS!","FREE BULLETS!","WELCOME TO EARTH! HAVE A NICE DEATH!","YER\'LL NEVER GET THEM PUMPKINS!","MY PUMPGUN MY PUMPKINS!","I\'LL CARVE YER FACE!","I\'LL CARVE YER FACE OFF!","IF YOU LOOK SO MUCH LIKE A PUMPKIN WHY AREN\'T YOU IN A CUP OF LATTE?","NO SOLICITORS!","KNOCK KNOCK. WHO\'S THERE? ALIEN. BANG YOU ARE NOW DEAD.","PROBE YOU WITH A SHOTGUN PELLET!","LOUD NOISES AND ANGRINESS!","SHOTGUN GUNSHOT!","WHAT TIME IS IT? SHOTGUN.","HELLO. BYE.","NO MERCY!","RELOAD. RESHOOT. REKILL."];
      
      internal var pumpkinlost:Array = ["OH THE PUMPKINITY!","ANOTHER PUMPKIN FALLS!","SHOOT FASTER!","SHOOT BETTER!","AIM BETTER!","NOOOOOOOOOOOOOOOOOOO!","THEY\'RE TAKING OUR PUMPKINS!","NOT THE PUMPKINS!","WHY WON\'T SOMEBODY THINK OF THE PUMPKINS!?","THEY\'VE TAKEN ANOTHER ONE!","ANOTHER PUMPKIN GONE!","PROTECT THE PUMPKINS!","SURELY THERE\'S AN END TO THIS MADNESS?","THIS IS HOPELESS","EVERYTHING WILL BURN","WE\'RE ALL GOING TO BE PROBED!","THIS IS THE END!","SAVE THE PUMPKINS!","NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!","NOOOO! THE PUMPKINS!"];
      
      internal var deadlines:Array = ["You have failed.","You just single-handedly killed everyone.","Did you at any point try shooting better?","Did you think about aiming better?","Maybe you didn\'t fail miserably in some other universe.","I\'m sure you tried your very best.","Don\'t worry. We\'ll all just be killed.","I\'m sure the aliens will just leave and not kill us all. Yeeeah.","Just so you know, there were only 239058203958 aliens left. You killed like... 0.1% of them.","It\'s not all bad. At least we\'ll know who to blame.","I mean, I had no expectations, and you still let me down.","Great job. At killing us all.","Great job. Not.","Press [Esc] to quit.","Press [Esc] to quit.","Press [Esc] to quit.","Press [Esc] to quit.","Well, at least you killed\nALIENSCORE aliens.","Well, at least you killed\nALIENSCORE aliens.","Well, killing ALIENSCORE aliens is\nbetter than nothing.","Well, killing ALIENSCORE aliens is\nbetter than nothing.","You downed ALIENSCORE saucers.","You downed ALIENSCORE saucers."
      ,"ALIENSCORE aliens went splurt.","ALIENSCORE aliens went splurt.","ALIENSCORE aliens down, a few hundred billion left.","ALIENSCORE aliens down, a few hundred billion left.","Only ALIENSCORE aliens killed? Could\'ve been a million.","Only ALIENSCORE aliens killed? Could\'ve been a million.","ALIENSCORE aliens destroyed.\nAnd now all of us.","ALIENSCORE aliens destroyed.\nAnd now all of us.","Just so you know, this game has no win condition, and I\'m being overly antagonistic to evoke an emotional response.","If only this game had a win condition and not just disappointment."];
      
      internal var pumpkincount:int = 5;
      
      public function PumpkinDefence()
      {
         Main.instance.stage.focus = null;
         Main.instance.reset(false,false);
         this.drones = new Vector.<b2Body>();
         super(GameState.width,GameState.height);
         enableClutter = false;
         enableFiller = false;
         enableParticles = false;
         enableSeed = false;
         _name = "pumpkindefence";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _backgroundColour = 2236962;
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
         IO.loadWorld("mutilate=2;walls=442c18;wallR=false;wallL=false;roof=false;particles=true;camera=300,0,0.75;loop=false;filler=false;autowind=false;seed=42;clutter=100;gravity=20;wind=0;temperature=37;breakalive=1,breakjoints=1,breakobjects=1,contacts=1|NM=makeshiftpipespear,PX=254.00,PY=479.00,AN=-14.00,DN=0,TM=37,LR=1,ghost=1;NM=makeshiftpipespear,PX=754.00,PY=482.00,AN=20.00,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencepost,PX=770.00,PY=506.00,AN=30.00,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencepost,PX=231.00,PY=514.00,AN=-33.00,SZ=0.95,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencesegment,PX=412.00,PY=536.00,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencesegment,PX=501.00,PY=536.00,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencesegment,PX=590.00,PY=536.00,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencesegment,PX=323.00,PY=536.00,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencesegment,PX=679.00,PY=536.00,DN=0,TM=37,LR=1,ghost=1;NM=woodensign,PX=111.00,PY=530.00,AN=-10.00,DN=0,TM=37,LR=1,ghost=1;NM=scaredrone,PX=499.00,PY=378.00,AN=0.03,SZ=1.0526315789473684,DN=0,TM=37,LR=1,TF=10,TR=150,TC=0,ghost=1,triggered=1;NM=residentialfencepost,PX=280.00,PY=480.00,SZ=1.1663507799970831,DN=0,TM=37,LR=1,aghost=1;NM=walkingplank,PX=376.00,PY=487.00,SZ=1.0526315789473681,DN=0,TM=37,LR=1,ghost=1;NM=residentialfencepost,PX=721.00,PY=482.00,SZ=1.166350779997083,DN=0,TM=37,LR=1,aghost=1;NM=walkingplank,PX=542.00,PY=487.00,SZ=1.0526315789473681,DN=0,TM=37,LR=1,ghost=1,flipped=1;NM=makeshiftpipespear,PX=806.00,PY=526.00,AN=50.00,SZ=0.9999999999999999,DN=0,TM=37,LR=1,ghost=1;NM=makeshiftpipespear,PX=198.00,PY=525.00,AN=-50.00,SZ=0.9999999999999999,DN=0,TM=37,LR=1,ghost=1;NM=alienhead,SZ=0.6,PX=108.00,PY=520.00,AN=-10.00,DN=0,TM=37,LR=1;NM=simplecrossalpha,SZ=0.4,PX=110.00,PY=528.00,AN=-55.00,DN=0,TM=37,LR=1|||ID=0,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=1,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=2,SKIN=7444334A2B20.7259513B2620;ID=3,SKIN=7444334A2B20.7259513B2620;ID=4,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=5,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=6,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=7,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=8,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=11,SKIN=744433573023.7259514B2F27;ID=12,SKIN=574531402509;ID=13,SKIN=744433573023.7259514B2F27;ID=14,SKIN=574531402509;ID=15,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=16,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=18,SKIN=777777760000;ID=9,SKIN=D6CCB62E1D02|||"
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
         Main.instance.cam.x = 50;
         Main.instance.cam.y = 180;
         Main.instance.cam.x = 200;
         this.score = 0;
         Tool.setTool("none");
         this.pumpkins = new Vector.<b2Body>();
         var _loc2_:Array = [0.75,0.9,1,0.9,0.75];
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc1_ = GameState.objects.spawnItem(O.getItem("pumpkin").vertices,[1],O.getItem("pumpkin").scale * _loc2_[_loc3_],"pumpkin",GameState.width * 0.5 - 125 + _loc3_ * 50,-580,0,O.getItem("pumpkin").colours);
            userData(_loc1_.GetUserData()).layer = 2;
            userData(_loc1_.GetUserData()).bulletproof = true;
            GraphicUtils.addGraphicToLayer(_loc1_.GetUserData());
            this.pumpkins.push(_loc1_);
            _loc3_++;
         }
         Vars.objDensity = 0;
         this.gun = GameState.objects.delayedSpawnObject("leveractionshotgun",440,360,90,false,true);
         userData(this.gun.GetUserData()).ghost = true;
         userData(this.gun.GetUserData()).zerograv = true;
         Vars.objDensity = 1;
         Vars.objDensity = 0;
         this.gun2 = GameState.objects.delayedSpawnObject("coachgun",570,360,-90,true,true);
         userData(this.gun2.GetUserData()).ghost = true;
         userData(this.gun2.GetUserData()).zerograv = true;
         Vars.objDensity = 1;
         var _loc4_:Number = 0;
         _loc4_ = 125;
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            this.pumpkins[_loc3_].SetXForm(new b2Vec2((GameState.width * 0.5 - _loc4_ + _loc3_ * 50) / Physics.scale,580 / Physics.scale),0);
            _loc3_++;
         }
         this.tutorial = 1;
         this.drone = O.getItem("dronespeaker").updateGraphic();
         this.drone.x = 200;
         this.drone.y = 200;
         this.drone.name = "openworlddrone";
         var _loc5_:Sprite = O.getItem("wheatstraw").updateGraphic();
         _loc5_.scaleX = -1;
         _loc5_.x = 30;
         this.drone.addChild(_loc5_);
         var _loc6_:Sprite = O.getItem("thevancleef").updateGraphic();
         _loc6_.scaleX = -1;
         _loc6_.x = 3;
         _loc6_.y = -15;
         this.drone.addChild(_loc6_);
         this.fader = new Sprite();
         this.fader.name = "openworldfader";
         this.fader.graphics.beginFill(0);
         this.fader.graphics.drawRect(0,0,1280,720);
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
         var _loc7_:TextFormat = this.tf.getTextFormat();
         _loc7_.align = TextFormatAlign.CENTER;
         this.tf.setTextFormat(_loc7_);
         this.tf.filters = [new GlowFilter(1118481,1,2,2,4)];
         Main.instance.stage.addChild(this.tf);
         Main.instance.stage.addChild(this.drone);
         Main.instance.stage.addChild(this.fader);
         this.animate();
         this.animaterotate();
         this.animatetext();
         this.animatefadein();
      }
      
      override public function update() : void
      {
         var _loc1_:* = 0;
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         if(_particles)
         {
            _loc4_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc5_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            if(Math.random() > 0.5)
            {
               this.rain.addParticles(1,_loc4_,_loc5_,0,0,4,4);
            }
            _loc4_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc4_,_loc5_,0,0,4,4);
            _loc4_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc4_,_loc5_,0,0,4,4);
         }
         super.update();
         if(!this.init)
         {
            this.Init();
         }
         this.tf.x += (-this.tf.x + this.drone.x + 50) * 0.02;
         this.tf.y += (-this.tf.y + this.drone.y - 25) * 0.02;
         if(this.pumpkins.length == 0)
         {
            this.dead = true;
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
         this.aim();
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
         if(Math.random() > 0.99)
         {
            this.targetPumpkin = int(this.pumpkins.length * Math.random());
         }
         var _loc2_:Number = 400 / Physics.scale;
         if(this.pumpkins.length > this.targetPumpkin)
         {
            _loc2_ = this.pumpkins[this.targetPumpkin].GetPosition().x;
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
            else
            {
               if(Math.random() > 0.95)
               {
                  _loc8_ = userData(this.drones[_loc1_].GetUserData()).triggerState;
                  _loc2_ += Math.random() * _loc8_ - _loc8_ * 0.5;
                  userData(this.drones[_loc1_].GetUserData()).triggerState = Math.random() * 100;
               }
               _loc6_ = this.drones[_loc1_].GetPosition();
               _loc7_ = new b2Vec2(_loc2_ + (Math.random() * 4 - 2),200 / Physics.scale);
               _loc7_.Subtract(_loc6_);
               _loc7_.Multiply(this.gamespeed);
               this.drones[_loc1_].ApplyForce(_loc7_,this.drones[_loc1_].GetPosition());
               this.drones[_loc1_].SetXForm(this.drones[_loc1_].GetPosition(),0);
            }
            _loc1_++;
         }
         var _loc3_:b2Body = Physics.world.GetBodyList();
         while(_loc3_)
         {
            if(userData(_loc3_.GetUserData()).hasBeenCut)
            {
               userData(_loc3_.GetUserData()).trigger = new Disintegrate("blood",50,10);
               userData(_loc3_.GetUserData()).triggered = true;
            }
            _loc3_ = _loc3_.GetNext();
         }
      }
      
      public function spawn(param1:TimerEvent) : void
      {
         var _loc2_:Vector.<Array> = new Vector.<Array>();
         _loc2_.push(["07a7c4","C19100"]);
         _loc2_.push(["b5b5b5","bb5b1b"]);
         _loc2_.push(["616161","3D2B19"]);
         _loc2_.push(["424242","202020"]);
         GameState.objects.spawnSkin = _loc2_;
         var _loc3_:b2Body = GameState.objects.spawnObject("dronesaucer",Math.random() * 1000 - 500,-500,0,false,true,_loc2_);
         userData(_loc3_.GetUserData()).alive = true;
         userData(_loc3_.GetUserData()).ignore = "dronesaucer";
         userData(_loc3_.GetUserData()).maxhealth = Math.min(1000,this.gamespeed * 0.1);
         userData(_loc3_.GetUserData()).health = userData(_loc3_.GetUserData()).maxhealth;
         userData(_loc3_.GetUserData()).triggerState = 100;
         userData(_loc3_.GetUserData()).bloodColour = 16742694;
         GameState.objects.spawnSkin = new Vector.<Array>();
         this.drones.push(_loc3_);
         this.gamespeed += 50;
         if(this.spawner.delay > 1000)
         {
            this.spawner.delay -= 50;
         }
      }
      
      public function aim() : *
      {
         var _loc2_:b2Body = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(GameState.isRightClickCapable)
         {
            if(GameState.mouseDown && this.tutorial == 0)
            {
               userData(this.gun.GetUserData()).triggered = true;
            }
            if(GameState.rightDown && this.tutorial == 0)
            {
               userData(this.gun2.GetUserData()).triggered = true;
            }
         }
         else if(GameState.mouseDown && this.tutorial == 0)
         {
            userData(this.gun.GetUserData()).triggered = true;
            userData(this.gun2.GetUserData()).triggered = true;
         }
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = _loc1_ == 0 ? this.gun : this.gun2;
            _loc3_ = 0;
            if(userData(_loc2_.GetUserData()).flipped)
            {
               _loc3_ = 180 * Vars.toRadians;
            }
            _loc4_ = Math.atan2(-Main.instance.mouseYWorld + _loc2_.GetPosition().y,-Main.instance.mouseXWorld + _loc2_.GetPosition().x);
            _loc4_ = _loc4_ - (_loc2_.GetAngle() % (Math.PI * 2) - (userData(_loc2_.GetUserData()).flipped ? Math.PI : 0));
            if(_loc4_ * Vars.toDegrees > 270)
            {
               _loc4_ -= Math.PI * 2;
            }
            if(_loc4_ * Vars.toDegrees < -270)
            {
               _loc4_ += Math.PI * 2;
            }
            _loc4_ *= Vars.toRadians * 5;
            _loc2_.SetXForm(_loc2_.GetPosition(),_loc2_.GetAngle() + _loc4_);
            _loc2_.WakeUp();
            _loc1_++;
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
               line = line.replace("CONTROLS","Aim with [Mouse].\nShoot left gun with [Left Mouse]\nand right gun with [Right Mouse].\nKill. Them. ALL.");
               if(this.tutorial >= this.tutoriallines.length)
               {
                  this.tutorial = 0;
                  this.spawner = new Timer(3000);
                  this.spawner.addEventListener(TimerEvent.TIMER,this.spawn);
                  this.spawner.start();
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
            "delay":this.tf.text.length * 0.05 + 0.5,
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
            sounds.play("halloweenmusic",null,null,1,true,9000);
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

