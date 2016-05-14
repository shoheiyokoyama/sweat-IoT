const int LED=13;
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
