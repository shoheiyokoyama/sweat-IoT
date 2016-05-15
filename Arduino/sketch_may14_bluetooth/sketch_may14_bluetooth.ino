//analogWriteを使う場合は、3番、5番、6番、9番、10番、11番のディジタルピンを使う必要がある
const int LED1 = 11;
const int LED2 = 10;
const int LED3 = 9;

const int MAX_VALUE = 256;
const int INCRESING_VALUE = 12;
const int DECREASING_VALUE = 12;
int rsvData = 0;
int sensorVal = 0;

void setup()
{
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  Serial.begin(9600);
}

void loop()
{  
//   digitalWrite(LED1, HIGH);
//   digitalWrite(LED2, HIGH);
//   digitalWrite(LED3, HIGH);

  // 受信処理
  if(Serial.available() > 0){
    rsvData = Serial.read();
    if(rsvData == 1){
      digitalWrite(LED1, HIGH);
    }else if(rsvData == 2){
      digitalWrite(LED2, HIGH);
    } else if(rsvData == 3) {
      digitalWrite(LED3, HIGH);
    } else {
//      digitalWrite(LED1, LOW);
    }
  }

  //センサー読み取り～送信
  sensorVal = analogRead(0);
  sensorVal = sensorVal>>2; //10bit->8bit値
  Serial.write(sensorVal);

  //ウェイト
  delay(100);
}

//後で使う用
void blink() {
  for ( int led_value = 0; led_value < MAX_VALUE; led_value += INCRESING_VALUE ) {
    analogWrite( LED1, led_value );
    delay( 30 );
  }
  for ( int led_value = 255; led_value > -1; led_value -= DECREASING_VALUE ) {
    analogWrite( LED1, led_value );
    delay( 30);
  }
}

