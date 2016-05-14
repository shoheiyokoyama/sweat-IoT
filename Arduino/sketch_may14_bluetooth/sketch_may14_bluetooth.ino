//analogWriteを使う場合は、3番、5番、6番、9番、10番、11番のディジタルピンを使う必要がある
const int LED = 11;
const int MAX_VALUE = 256;
const int INCRESING_VALUE = 24;
const int DECREASING_VALUE = 24;
int rsvData = 0;
int sensorVal = 0;

void setup()
{
  pinMode(LED, OUTPUT);
  Serial.begin(9600);
}

void loop()
{  
  digitalWrite(LED, HIGH);

  // 受信処理
  if(Serial.available() > 0){
    rsvData = Serial.read();
    if(rsvData == 1){
      digitalWrite(LED, HIGH);
    }else if(rsvData == 0){
      digitalWrite(LED, LOW);
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
    analogWrite( LED, led_value );
    delay( 30 );
  }
  for ( int led_value = 255; led_value > -1; led_value -= DECREASING_VALUE ) {
    analogWrite( LED, led_value );
    delay( 30);
  }
}

