#include <Wire.h>
#include "DHT.h"
#include "HDC.h"

#define DHTPIN           8         // AM2302接続ピン
#define DHTTYPE          DHT22     // DHT 22  (AM2302)

#define HDC1000_ADRS     0x40      // HDC1000のI2Cアドレス

HDC hdc(HDC1000_ID, HDC1000_ADRS) ;
DHT dht(DHTPIN, DHTTYPE) ;

void setup()
{
     int ans ;

     // シリアルモニターの設定
     Serial.begin(9600) ;
     // Ｉ２Ｃの初期化
     Wire.begin() ;                // マスターとする
     delay(3000) ;                 // 3Sしたら開始
     // HDC1000の初期化
     ans = hdc.Init() ;
     if (ans != 0) {
          Serial.print("HDC Initialization abnormal ans=") ;
          Serial.println(ans) ;
     } else Serial.println("HDC Initialization normal !!") ;
     // AM2302の初期化
     dht.begin() ;
}
void loop()
{
     float h, t ;
     int ans ;

     // HDC1000から湿度と温度を読み取る
     ans = hdc.Read() ;
     if (ans == 0) {
          Serial.print("HDC1000: ") ;
          Serial.print(Humi) ;
          Serial.print("%  ") ;
          Serial.print(Temp) ;
          Serial.println("'C") ;
     } else {
          Serial.print("Failed to read from HDC ans=") ;
          Serial.println(ans) ;
     }
     // AM2302から湿度と温度を読み取る
     h = dht.readHumidity() ;
     t = dht.readTemperature() ;
     if (isnan(t) || isnan(h)) {
          Serial.println("Failed to read from DHT");
     } else {
          Serial.print("AM2302 : "); 
          Serial.print(h);
          Serial.print("% ");
          Serial.print(t);
          Serial.println("'C");
     }

     delay(1000) ;                      // １秒後に繰り返す
}
