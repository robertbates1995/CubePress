from machine import Pin, PWM
from utime import sleep_ms
import network, socket, secrets, time, servos, json

############################################# MAIN PROGRAM ####################################################
def read_settings_file():
    f = open(file_name,'r')
    settings_string = f.read()
    f.close()
    return settings_string
    
def create_settings_dictionary():
    #initalize servos
    settings_string = read_settings_file()
    dictionary = json.loads(settings_string)
    print('Data:', dictionary)
    return dictionary

def update_settings_dictionary():
    f = open(file_name,'w')
    print("Dumping to JSON")
    json.dump(settings_dictionary, f)
    arm = servos.arm_servo(settings_dictionary['bot'],settings_dictionary['mid'],settings_dictionary['top'], 15)
    table = servos.table_servo(settings_dictionary['left'],settings_dictionary['center'],settings_dictionary['right'], 16)
    f.close()

def handle_settings(request):
    parts = request.split("/")
    length = len(parts)
    print("request parts: ", parts)
    if length != 2:
        print("parts[3]:", int(parts[3]))
        settings_dictionary[parts[2]] = int(parts[3])
        print("settings dictionary: ", settings_dictionary)
        update_settings_dictionary()
    return read_settings_file()


file_name = 'settings.json' #JSON workspace
f = open(file_name,'r')
settings_string = f.read()
f.close()
print('Got settings:', settings_string)
settings_dictionary = create_settings_dictionary() #dictionary based on JSON workspace
arm = servos.arm_servo(settings_dictionary['bot'],settings_dictionary['mid'],settings_dictionary['top'], 15) #initalizing arm servo
table = servos.table_servo(settings_dictionary['left'],settings_dictionary['center'],settings_dictionary['right'], 16) #initalizing table servo

#set secret values
ssid = secrets.ssid
password = secrets.password

#connect to local network
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(ssid, password)


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
        request = str(request)
        request = request.split(" ")[1]
        if "settings" in request:
            print("settings")
            response = handle_settings(request)
        #else:
        #return servo settings here
        elif 'bot' in request:
            arm.move_bot()
        elif 'mid' in request:
            arm.move_mid()
        elif 'top' in request:
            arm.move_top()
        elif 'left' in request:
            print("current left value: ", table.left)
            table.move_left()
        elif 'center' in request:
            table.move_center()
        elif 'right' in request:
            table.move_right()
        else:
            print("No Instruction")
        # Create and send response
        cl.send('HTTP/1.0 200 OK\r\nContent-type: text/json\r\n\r\n')
        cl.send(response)
        cl.close()
        
    except OSError as e:
        cl.close()
        print('connection closed')