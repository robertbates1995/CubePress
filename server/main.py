from machine import Pin, PWM, Timer
from utime import sleep_ms
import sys, select, network, socket, secrets


class arm_servo:
    servo = PWM(Pin(15))
    # arm servo, connected to Pin 15
    bot = int
    mid = int
    top = int
    
    def test(self):
        self.move_top()
        print("top = " + str(self.top))
        sleep_ms(1200)
        self.move_bot()
        print("bottom = " + str(self.bot))
        sleep_ms(1200)
        self.move_mid()
        print("middle = " + str(self.mid))
        sleep_ms(1200)
    
    def move_bot(self):
        self.servo.duty_ns(self.bot)
        sleep_ms(50)
        
    def move_mid(self):
        self.servo.duty_ns(self.mid)
        sleep_ms(50)
        
    def move_top(self):
        self.servo.duty_ns(self.top)
        sleep_ms(50)
        
    def __init__(self, a, b, c):
        self.servo.freq(50) 
        sleep_ms(50)
        self.bot = a
        self.mid = b
        self.top = c
        
class table_servo:
    servo = PWM(Pin(16))
    # arm servo, connected to Pin 16
    left = int
    mid = int
    right = int
    
    def test(self):
        self.move_left()
        print("left = " + str(self.left))
        sleep_ms(1200)
        self.move_right()
        print("right = " + str(self.right))
        sleep_ms(1200)
        self.move_mid()
        print("middle = " + str(self.mid))
        sleep_ms(1200)
    
    def move_left(self):
        self.servo.duty_ns(self.left)
        sleep_ms(50)
        
    def move_mid(self):
        self.servo.duty_ns(self.mid)
        sleep_ms(50)
        
    def move_right(self):
        self.servo.duty_ns(self.right)
        sleep_ms(50)
        
    def __init__(self, a, b, c):
        self.servo.freq(50)
        sleep_ms(50)
        self.left = a
        self.mid = b
        self.right = c



#def main_func():
    
    
############################################# MAIN PROGRAM ####################################################

ssid = secrets.ssid
password = secrets.password

wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(ssid, password)
    
html = """<!DOCTYPE html>
<html>
<head> <title>Pico W</title> </head>
<body> <h1>Pico W HTTP Server</h1>
<p>Hello, World!</p>
<p>%s</p>
</body>
</html>
"""

# Wait for connect or fail
max_wait = 10
while max_wait > 0:
    if wlan.status() < 0 or wlan.status() >= 3:
        break
    max_wait -= 1
    print('waiting for connection...')
    time.sleep(1)
    
# Handle connection error
if wlan.status() != 3:
    raise RuntimeError('network connection failed')
else:
    print('Connected')
    status = wlan.ifconfig()
    print( 'ip = ' + status[0] )
    
    
# Open socket
addr = socket.getaddrinfo('0.0.0.0', 80)[0][-1]
s = socket.socket()
s.bind(addr)
s.listen(1)
print('listening on', addr)

# Listen for connections, serve client
while True:
    try:       
        cl, addr = s.accept()
        print('client connected from', addr)
        request = cl.recv(1024)
        print("request:")
        print(request)
        request = str(request)
        led_on = request.find('led=on')
        led_off = request.find('led=off')
        
        print( 'led on = ' + str(led_on))
        print( 'led off = ' + str(led_off))
        
        if led_on > -1:
            print("led on")
            led.value(1)
        if led_off == 8:
            print("led off")
            led.value(0)
        
        ledState = "LED is OFF" if led.value() == 0 else "LED is ON" # a compact if-else statement
        
        if button.value() == 1: # button not pressed
            print("button NOT pressed")
            buttonState = "Button is NOT pressed"
        else:
            print("button pressed")
            buttonState = "Button is pressed"
        
        # Create and send response
        stateis = ledState + " and " + buttonState
        response = html % stateis
        cl.send('HTTP/1.0 200 OK\r\nContent-type: text/html\r\n\r\n')
        cl.send(response)
        cl.close()
        
    except OSError as e:
        cl.close()
        print('connection closed')