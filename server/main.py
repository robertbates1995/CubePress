from machine import Pin, PWM
from utime import sleep_ms
import sys, select, network, socket, secrets, time, servos

############################################# MAIN PROGRAM ####################################################

#initalize servos
arm = servos.arm_servo(1600000,1230000,750000, 15)
table = servos.table_servo(3000000,1550000,600000, 16)

#set secret values
ssid = secrets.ssid
password = secrets.password

#connect to local network
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(ssid, password)

#webpage html
html = """<!DOCTYPE html>
<html>
<head> <title>Pico W</title> </head>
<body> <h1>Bob's Pico W HTTP Server</h1>
<p>Hello, World!</p>
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
        #print("request:")
        #print(request)
        request = str(request)
            
        move = request.split('==')[1]
        print("MOVE IS THIS:     " + str(move))
        if 'bot' in move:
            arm.move(move)
        elif 'mid' in move:
            arm.move(move)
        elif 'top' in move:
            arm.move(move)
        elif 'left' in move:
            table.move(move)
        elif 'center' in move:
            table.move(move)
        elif 'right' in move:
            table.move(move)
        else:
            print("No Valid Instruction")
        
        # Create and send response
        response = html
        cl.send('HTTP/1.0 200 OK\r\nContent-type: text/html\r\n\r\n')
        cl.send(response)
        cl.close()
        
    except OSError as e:
        cl.close()
        print('connection closed')