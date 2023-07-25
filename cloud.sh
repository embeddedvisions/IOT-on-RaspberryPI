echo -n "26" > /sys/class/gpio/export
echo -n "out" > /sys/class/gpio/gpio26/direction
echo -n "19" > /sys/class/gpio/export
echo -n "out" > /sys/class/gpio/gpio19/direction
echo -n "21" > /sys/class/gpio/export
echo -n "20" > /sys/class/gpio/export
echo -n "16" > /sys/class/gpio/export
echo -n "12" > /sys/class/gpio/export
echo -n "13" > /sys/class/gpio/export
echo -n "18" > /sys/class/gpio/export
echo -n "out" > /sys/class/gpio/gpio21/direction
echo -n "out" > /sys/class/gpio/gpio20/direction
echo -n "out" > /sys/class/gpio/gpio16/direction
echo -n "out" > /sys/class/gpio/gpio12/direction
echo -n "out" > /sys/class/gpio/gpio13/direction
echo -n "in" > /sys/class/gpio/gpio18/direction


#Checing Internet Connectivity

if ping -q -c 5 -W 10 192.168.43.166 >/dev/null; then
echo "Network Detected"
echo -n "1" > /sys/class/gpio/gpio26/value
echo -n "0" > /sys/class/gpio/gpio19/value
sleep 1
else

  echo "Network Connection not detected! Please check network settings"
  echo -n "0" > /sys/class/gpio/gpio26/value
  echo -n "1" > /sys/class/gpio/gpio19/value
fi

mosquitto_sub -h 192.168.43.166 -p 1889  -t "Room1" > room1.txt &
mosquitto_sub -h 192.168.43.166 -p 1889  -t "Room2" > room2.txt &
mosquitto_sub -h 192.168.43.166 -p 1889  -t "Room3" > room3.txt &
mosquitto_sub -h 192.168.43.166 -p 1889  -t "Room4" > room4.txt &
mosquitto_sub -h 192.168.43.166 -p 1889  -t "Buzzer" > buzzer.txt &
while :
do
  sleep 1
#****Room 1 Section*********
 
  foo=$(tail -n 1 room1.txt)
if [ "$foo" == "1" ]; then
  echo -n "1" > /sys/class/gpio/gpio21/value
  echo "Room1 Light OFF" 
elif [ "$foo" == "0" ]; then
  echo -n "0" > /sys/class/gpio/gpio21/value
  echo "Room1 Light ON" 
fi

#****Room 2 Sectiom********

  foo1=$(tail -n 1 room2.txt)
if [ "$foo1" == "1" ]; then
  echo -n "1" > /sys/class/gpio/gpio20/value
  echo "Room2 Light OFF"
elif [ "$foo1" == "0" ]; then
  echo -n "0" > /sys/class/gpio/gpio20/value
  echo "Room2 Light ON"
fi

#****Room3 Section*******

  foo2=$(tail -n 1 room3.txt)
if [ "$foo2" == "1" ]; then
  echo -n "1" > /sys/class/gpio/gpio16/value
  echo "Room3 Light OFF"
elif [ "$foo2" == "0" ]; then
  echo -n "0" > /sys/class/gpio/gpio16/value
  echo "Room3 Light ON"
fi


#*****Room4 Section*******

  foo3=$(tail -n 1 room4.txt)
if [ "$foo3" == "1" ]; then
  echo -n "1" > /sys/class/gpio/gpio12/value
  echo "Room4 Light OFF"
elif [ "$foo3" == "0" ]; then
  echo -n "0" > /sys/class/gpio/gpio12/value
  echo "Room4 Light ON"
fi

#*****Buzzer Section******


  foo4=$(tail -n 1 buzzer.txt)
if [ "$foo4" == "1" ]; then
  echo -n "1" > /sys/class/gpio/gpio13/value
  echo "Buzzer ON"
elif [ "$foo4" == "0" ]; then
  echo -n "0" > /sys/class/gpio/gpio13/value
  echo "Buzzer OFF"
fi


#****Input Section**********

  var=$(cat /sys/class/gpio/gpio18/value)
if [ "$var" == "1" ]; then
  mosquitto_pub -h 192.168.43.166 -p 1889 -t "Door1" -m "Open"
elif [ "$var" == "0" ]; then 
  mosquitto_pub -h 192.168.43.166 -p 1889 -t "Door1" -m "Close"
fi
    
done
