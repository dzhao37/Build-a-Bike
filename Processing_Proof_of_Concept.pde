// https://downloads.khinsider.com/game-soundtracks/album/mario-kart-8/1-01%2520Mario%2520Kart%25208.mp3
// https://themushroomkingdom.net/media/smb/wav
// http://soundfxcenter.com/download-sound/mario-kart-64-toad-okay-sound-effect/
// https://www.101soundboards.com/boards/10636-birdo-sounds-mario-kart-double-dash



// initialize sound and serial library
import processing.serial.*;
import processing.sound.*;
//initialize serial connection variables
Serial myPort;
String serialInput;


// create image and sound effect variables
PImage start, toad_selected, birdo_selected, wario_selected, toad_mission, birdo_mission, wario_mission, directions, default_selection, selection, result, toad_low, toad_medium, toad_high, birdo_low, birdo_medium, birdo_high, wario_low, wario_medium, wario_high, replay;  // declare image variable
SoundFile MK8_Title, MK8_Main_Menu, OGMK_Title, OGMK_Main_Menu, NSMB_Title_Screen, Toad_House, lets_a_go, coin, yoshi, pipe, racestart, mario_die, power_up, one_Up, SS, stage_clear, game_over, t_HIYAH, t_alright, t_go, t_next_time, t_almost, t_YAHOO, b_birdo, b_byong, b_lets_go, b_ah, b_wow, b_yay, w_alright, w_excellent, w_good_luck, w_good, w_i_win, w_uh_oh, w_welcome; // declare sound variable

// global variables to store 108 cursor screens and 36 results screens
String screen_name, result_name;

// global variables to vary background music and store mission selected
int song_num = 0;
int mission_selected = 0;

// global variables to control stage of the game process and screen displays
boolean choosing_mission = false;
boolean choosing_selection = false;
// global variable to ensure sound effects do not overlap
boolean played = false;


// global variables to store score
float score = 0;
float power = 0;
float sustainability = 0;


// store user position
int row = 0;
int column = 0;

// store user selection
int col1 = 0;
int col2 = 0;
int col3 = 0;



void setup() {
  //Launches GUI full screen
  fullScreen();
 
  // Configure serial communication
  String portName = "/dev/cu.usbmodem101";                   
  myPort = new Serial(this, portName, 9600);
  
  
  // load images
  start = loadImage("start.jpg");
  toad_selected = loadImage("toad_mission_selected.jpg");
  birdo_selected = loadImage("birdo_mission_selected.jpg");
  wario_selected = loadImage("wario_mission_selected.jpg");
  toad_mission = loadImage("toad_mission.jpg");
  birdo_mission = loadImage("birdo_mission.jpg");
  wario_mission = loadImage("wario_mission.jpg");
  directions = loadImage("directions.jpg");
  default_selection = loadImage("oneoneoneone.jpg");
  result = loadImage("Results-oneoneone.jpg");
  toad_low = loadImage("toad_low_score.jpg");
  toad_medium = loadImage("toad_medium_score.jpg");
  toad_high = loadImage("toad_perfect_score.jpg");
  birdo_low = loadImage("birdo_low_score.jpg");
  birdo_medium = loadImage("birdo_medium_score.jpg");
  birdo_high = loadImage("birdo_perfect_score.jpg");
  wario_low = loadImage("wario_low_score.jpg");
  wario_medium = loadImage("wario_medium_score.jpg");
  wario_high = loadImage("wario_perfect_score.jpg");
  replay = loadImage("play again.jpg");
  
  // load sounds
  MK8_Title = new SoundFile(this, "MK8 Title.mp3");
  MK8_Main_Menu = new SoundFile(this, "MK8 Main Menu.mp3");
  OGMK_Title = new SoundFile(this, "OGMK Title.mp3");
  OGMK_Main_Menu = new SoundFile(this, "OGMK Main Menu.mp3");
  NSMB_Title_Screen = new SoundFile(this, "NSMB Title Screen.mp3");
  Toad_House = new SoundFile(this, "Toad House.mp3");
  lets_a_go = new SoundFile(this, "lets a go.wav");
  coin = new SoundFile(this, "coin.wav");
  yoshi = new SoundFile(this, "yoshi.wav");
  pipe = new SoundFile(this, "pipe.wav");
  racestart = new SoundFile(this, "racestart.wav");
  mario_die = new SoundFile(this, "mario die.wav");
  power_up = new SoundFile(this, "power_up.wav");
  one_Up = new SoundFile(this, "1-Up.wav");
  SS = new SoundFile(this, "Super Mario Bros Invincibility Theme Sound Effect.wav");
  stage_clear = new SoundFile(this, "stage clear.wav");
  game_over = new SoundFile(this, "game over.wav");
  t_HIYAH = new SoundFile(this, "t HIYAH.wav");
  t_alright = new SoundFile(this, "t alright.wav");
  t_go = new SoundFile(this, "t go.wav");
  t_next_time = new SoundFile(this, "t next time.wav");
  t_almost = new SoundFile(this, "t almost.wav");
  t_YAHOO = new SoundFile(this, "t YAHOO.wav");
  b_birdo = new SoundFile(this, "b birdo.wav");
  b_byong = new SoundFile(this, "b byong.wav");
  b_lets_go = new SoundFile(this, "b lets go.wav");
  b_ah = new SoundFile(this, "b ah.wav");
  b_wow = new SoundFile(this, "b wow.wav");
  b_yay = new SoundFile(this, "b yay.wav");
  w_alright = new SoundFile(this, "w alright.mp3");
  w_excellent = new SoundFile(this, "w excellent.mp3");
  w_good_luck = new SoundFile(this, "w good-luck.mp3");
  w_good = new SoundFile(this, "w good.mp3");
  w_i_win = new SoundFile(this, "w i-win.mp3");
  w_uh_oh = new SoundFile(this, "w uh-oh.mp3");
  w_welcome = new SoundFile(this, "w welcome.mp3");
  
  
  // show title screen
  start.resize(0, 900);
  image(start, 0, 0);
  
  // play background music
  if(song_num == 0) {
    MK8_Title.play();
    MK8_Title.amp(0.4);
    MK8_Title.loop();
  } else if(song_num == 1) {
    MK8_Main_Menu.play();
    MK8_Main_Menu.amp(0.4);
    MK8_Main_Menu.loop();
  } else if(song_num == 2) {
    OGMK_Title.play();
    OGMK_Title.amp(0.4);
    OGMK_Title.loop();
  } else if(song_num == 3) {
    OGMK_Main_Menu.play();
    OGMK_Main_Menu.amp(0.4);
    OGMK_Main_Menu.loop();
  } else if(song_num == 4) {
    NSMB_Title_Screen.play();
    NSMB_Title_Screen.amp(0.4);
    NSMB_Title_Screen.loop();
  } else if(song_num == 5) {
    Toad_House.play();
    Toad_House.amp(0.4);
    Toad_House.loop();
  }
  
  lets_a_go.play();
}



void draw() {
  // if data is available in the Serial monitor, run the following code
  if(myPort.available() > 0) {
    // read the line and store in serialInput
    serialInput = myPort.readStringUntil('\n'); 
    println(serialInput);
    if(serialInput != null) {
      // remove any whitespace from the end
      serialInput = trim(serialInput); 
    }
  }
  
  
  // display logic for introduction
  if("show mission select".equals(serialInput)) {
    // activate mission display controls
    choosing_mission = true;
    
    // show default toad mission selection
    toad_selected.resize(0, 900);
    image(toad_selected, 0, 0);
    
    t_HIYAH.play();
    
  } else if("show mission".equals(serialInput)) {
    // deactivate mission display controls
    choosing_mission = false;
    
    // checks mission selected and displays corresponding mission instructions and
    // sound effects; ensures sound effect is only played once
    if(mission_selected == 0) {
      toad_mission.resize(0, 900);
      image(toad_mission, 0, 0);
      if(!played) {
        played = true;
        t_alright.play();
      }
    } else if(mission_selected == 1) {
      birdo_mission.resize(0, 900);
      image(birdo_mission, 0, 0);
      if(!played) {
        played = true;
        b_byong.play();
      }
    } else if(mission_selected == 2) {
      wario_mission.resize(0, 900);
      image(wario_mission, 0, 0);
      if(!played) {
        played = true;
        w_welcome.play();
      }
    }
    
  } else if("show directions".equals(serialInput)) {
    directions.resize(0, 900);
    image(directions, 0, 0);
    yoshi.play();
    
  } else if("begin selection".equals(serialInput)) {
    // activate bike selection display controls
    choosing_selection = true;
    
    // display default oneoneoneone bike
    default_selection.resize(0, 900);
    image(default_selection, 0, 0);
    
    if(mission_selected == 0) {
      t_go.play();
    } else if(mission_selected == 1) {
      b_lets_go.play();
    } else if(mission_selected == 2) {
      w_good_luck.play();
    }
  }
  
  
  // mission select logic and display controls
  if(choosing_mission) {
    if("Left".equals(serialInput)) {
      // prevents going left if on leftmost mission
      if(mission_selected >= 1) {
        // update mission selected and display corresponding cursor image
        mission_selected--;
        display_mission_selection(mission_selected);
      }
    } else if("Right".equals(serialInput)) {
      // prevents going right if on rightmost mission
      if(mission_selected <= 1) {
        // update mission selected and display corresponding cursor image
        mission_selected++;
        display_mission_selection(mission_selected);
      }
    }
  }
  
  
  // bike select logic and display controls
  if(choosing_selection) {
    // read joystick input and update screen accordingly
    if("Up".equals(serialInput)) {
      // prevents going up if on topmost selection
      if(row >= 1) {
        row--;
        
        // store updated position
        if(column == 0) {
          col1 = row;
        } else if(column == 1) {
          col2 = row;
        } else if(column == 2) {
          col3 = row;
        }
        
        display_selection(column, col1, col2, col3);
      }
    } else if("Down".equals(serialInput)) {
      // column 1 is a special case since there are 4 selections
      if(column == 0) {
        // prevents going down if on bottommost selection
        if(row <= 2) {
          row++;
          
          // store updated position and display corresponding screen
          col1 = row;
          display_selection(column, col1, col2, col3);
        }
      } else if(column >= 1) {
        // for columns 2 and 3 which have 3 selections, prevent going down if on the 
        // 3rd selection from the top
        if(row <= 1) {
          row++;
          
          // store position
          if(column == 1) {
            col2 = row;
          } else if(column == 2) {
            col3 = row;
          }
          
          display_selection(column, col1, col2, col3);
        }
      }
    } else if("Right".equals(serialInput)) {
      // prevents going right if on rightmost column
      if(column <= 1) {
        column++;    
        
        // update position
        if(column == 1) {
          row = col2;
        } else if(column == 2) {
          row = col3;
          // send column data to Arduino to indicate a complete selection and allow for
          // a submission
          myPort.write(column);
        }
        
        display_selection(column, col1, col2, col3);
      }
    } else if("Left".equals(serialInput)) { // a bit finicky rn
      // prevents going left if on the leftmost column
      if(column >= 1) {
        column--;
        
        // update selection
        if(column == 1) {
          row = col2;
        } else if(column == 0) {
          row = col1;
        }
        
        display_selection(column, col1, col2, col3);
      }
    }
  }
   
  
  // screen and sound logic for displaying the result once the bike is submitted
  if("result".equals(serialInput)) {
    // deactivate selection logic
    choosing_selection = false;
    
    // display results screen
    result_name = "Results-" + convert(col1) + convert(col2) + convert(col3) + ".jpg";
    result = loadImage(result_name);
    result.resize(0, 900);
    image(result, 0, 0);
    
    // stop background music
    if(song_num == 0) {
      MK8_Title.stop();
    } else if(song_num == 1) {
      MK8_Main_Menu.stop();
    } else if(song_num == 2) {
      OGMK_Title.stop();
    } else if(song_num == 3) {
      OGMK_Main_Menu.stop();
    } else if(song_num == 4) {
      NSMB_Title_Screen.stop();
    } else if(song_num == 5) {
      Toad_House.stop();
    }
    racestart.play();
    
  } else if("display mission result".equals(serialInput)) {
    // let the sound effects finish playing
    delay(3000);
    
    // calculate score and send to Arduino to control outputs
    score = calculate(col1, col2, col3, mission_selected);
    myPort.write(round(score));
    println("Processing score: " + round(score));
    
    delay(500);
    display_mission_result(mission_selected, round(score));
  }
  
  
  if("coin".equals(serialInput)) {
    // sound effect for each button press
    coin.play();
    coin.amp(0.3);
  } else if("pipe".equals(serialInput)) {
    // sound effect for bike submission
    pipe.play();
  } else if("mario die".equals(serialInput)) {
    // sound effect for low bucket score
    mario_die.play();
    delay(7500);
    
    // display play again screen and play sound effect
    replay.resize(0, 900);
    image(replay, 0, 0);
    game_over.play();
  } else if("power up".equals(serialInput)) {
    // sound effect for medium bucket score
    delay(1000);
    power_up.play();
    delay(2000);
    one_Up.play();
    delay(7000);
    
    // display play again screen and play sound effect
    replay.resize(0, 900);
    image(replay, 0, 0);
    game_over.play();
  } else if("Shooting Star".equals(serialInput)) {
    // sound effect for high bucket score
    SS.play();
    delay(9000);
    stage_clear.play();
    delay(6000);
    
    // display play again screen and play sound effect
    replay.resize(0, 900);
    image(replay, 0, 0);
    game_over.play();
  }
  
  
  if("reset".equals(serialInput)) {    
    // switch to next background song
    if(song_num < 5) {
      song_num++;
    } else{
      song_num = 0;
    }
    
    // reset global variables
    played = false;
    mission_selected = 0;
    
    // reset user position
    row = 0;
    column = 0;
    
    // reset selection
    col1 = 0;
    col2 = 0;
    col3 = 0;
    
    // reset score
    score = 0;
    power = 0;
    sustainability = 0;
    
    // display title screen
    start.resize(0, 900);
    image(start, 0, 0);
    
    // play background music
    if(song_num == 0) {
      MK8_Title.play();
      MK8_Title.amp(0.4);
      MK8_Title.loop();
    } else if(song_num == 1) {
      MK8_Main_Menu.play();
      MK8_Main_Menu.amp(0.4);
      MK8_Main_Menu.loop();
    } else if(song_num == 2) {
      OGMK_Title.play();
      OGMK_Title.amp(0.4);
      OGMK_Title.loop();
    } else if(song_num == 3) {
      OGMK_Main_Menu.play();
      OGMK_Main_Menu.amp(0.4);
      OGMK_Main_Menu.loop();
    } else if(song_num == 4) {
      NSMB_Title_Screen.play();
      NSMB_Title_Screen.amp(0.4);
      NSMB_Title_Screen.loop();
    } else if(song_num == 5) {
      Toad_House.play();
      Toad_House.amp(0.4);
      Toad_House.loop();
    }
    lets_a_go.play();
  }
}



//------------------------------------------------------------------------------------------



// this function displays the updated cursor mission selected and plays the corresponding
// sound effect given the mission number
void display_mission_selection(int mission_num) {
  if(mission_num == 0) {
    toad_selected.resize(0, 900);
    image(toad_selected, 0, 0);
    t_HIYAH.play();
  } else if(mission_num == 1) {
    birdo_selected.resize(0, 900);
    image(birdo_selected, 0, 0);
    b_birdo.play();
  } else if(mission_num == 2) {
    wario_selected.resize(0, 900);
    image(wario_selected, 0, 0);
    w_alright.play();
  }
}

// this function converts an integer selection into its string form in order to call the
// right image
String convert(int colNum) {
  String strColNum = "one";
  if(colNum == 0) {
    strColNum = "one";
  } else if(colNum == 1) {
    strColNum = "two";
  } else if(colNum == 2) {
    strColNum = "three";
  } else if(colNum == 3) {
    strColNum = "four";
  }
  return strColNum;
}

// this function displays the corresponding selection screen given the stored position
// for each column as well as the cursor position
void display_selection(int cursor, int c1, int c2, int c3) {
  screen_name = convert(cursor) + convert(c1) + convert(c2) + convert(c3) + ".jpg";
  selection = loadImage(screen_name);
  selection.resize(0, 900);
  image(selection,0,0);
}

// this function calculates the score given the stored position for each column
float calculate(int c1, int c2, int c3, int mission_num) {
  float combined_score = 0;
  
  // calculate power and sustainability score and combine to get total score
  // sustainability score is the same for each selection, whereas the power score for each
  // selection varies by mission
  if(c1 == 0) {
    if(mission_num == 0) {
      power += 6;
    } else if(mission_num == 1) {
      power += 6;
    } else if(mission_num == 2) {
      power += 8;
    }
    sustainability += 6;
  } else if(c1 == 1) {
    if(mission_num == 0) {
      power += 4;
    } else if(mission_num == 1) {
      power += 8;
    } else if(mission_num == 2) {
      power += 6;
    }
    sustainability += 4;
  } else if(c1 == 2) {
    if(mission_num == 0) {
      power += 2;
    } else if(mission_num == 1) {
      power += 4;
    } else if(mission_num == 2) {
      power += 4;
    }
    sustainability += 2;
  } else if(c1 == 3) {
    if(mission_num == 0) {
      power += 8;
    } else if(mission_num == 1) {
      power += 2;
    } else if(mission_num == 2) {
      power += 2;
    }
    sustainability += 8;
  }
  
  if(c2 == 0) {
    if(mission_num == 0) {
      power += 1;
    } else if(mission_num == 1) {
      power += 3;
    } else if(mission_num == 2) {
      power += 1;
    }
    sustainability += 3;
  } else if(c2 == 1) {
    if(mission_num == 0) {
      power += 3;
    } else if(mission_num == 1) {
      power += 1;
    } else if(mission_num == 2) {
      power += 3;
    }
    sustainability += 1;
  } else if(c2 == 2) {
    if(mission_num == 0) {
      power += 2;
    } else if(mission_num == 1) {
      power += 2;
    } else if(mission_num == 2) {
      power += 2;
    }
    sustainability += 2;
  }
  
  if(c3 == 0) {
    if(mission_num == 0) {
      power += 2;
    } else if(mission_num == 1) {
      power += 3;
    } else if(mission_num == 2) {
      power += 2;
    }
    sustainability += 2;
  } else if(c3 == 1) {
    if(mission_num == 0) {
      power += 3;
    } else if(mission_num == 1) {
      power += 1;
    } else if(mission_num == 2) {
      power += 1;
    }
    sustainability += 1;
  } else if(c3 == 2) {
    if(mission_num == 0) {
      power += 1;
    } else if(mission_num == 1) {
      power += 2;
    } else if(mission_num == 2) {
      power += 3;
    }
    sustainability += 3;
  }
  
  //calculate total score
  combined_score = (0.1 * sustainability + 0.6) * power;
  return combined_score;
}

// this function displays how well the user met the mission task and plays corresponding
// sound effects given the mission selected and score
void display_mission_result(int mission_num, float score) {
  if(mission_num == 0) {
    if(score < 16) {
      toad_low.resize(0, 900);
      image(toad_low, 0, 0);
      t_next_time.play();
    } else if(score < 21) {
      toad_medium.resize(0, 900);
      image(toad_medium, 0, 0);
      t_almost.play();
    } else if(score >= 21) {
      toad_high.resize(0, 900);
      image(toad_high, 0, 0);
      t_YAHOO.play();
    }
  } else if(mission_num == 1) {
    if(score < 16) {
      birdo_low.resize(0, 900);
      image(birdo_low, 0, 0);
      b_ah.play();
    } else if(score < 21) {
      birdo_medium.resize(0, 900);
      image(birdo_medium, 0, 0);
      b_wow.play();
    } else if(score >= 21) {
      birdo_high.resize(0, 900);
      image(birdo_high, 0, 0);
      b_yay.play();
    }
  } else if(mission_num == 2) {
    if(score < 16) {
      wario_low.resize(0, 900);
      image(wario_low, 0, 0);
      w_uh_oh.play();
    } else if(score < 21) {
      wario_medium.resize(0, 900);
      image(wario_medium, 0, 0);
      w_good.play();
    } else if(score >= 21) {
      wario_high.resize(0, 900);
      image(wario_high, 0, 0);
      w_excellent.play();
      delay(1000);
      w_i_win.play();
    }
  }
}
