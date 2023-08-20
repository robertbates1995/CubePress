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
    global arm
    global table
    f = open(file_name,'w')
    print("Dumping to JSON")
    json.dump(settings_dictionary, f)
    arm = servos.arm_servo(settings_dictionary['bot'],settings_dictionary['mid'],settings_dictionary['top'], 15) #initalizing arm servo
    table = servos.table_servo(settings_dictionary['left'],
                           settings_dictionary['center'],
                           settings_dictionary['right'], 14) #initalizing table servo
    f.close()

def handle_settings(request):
    parts = request.split("/")
    length = len(parts)
    print("request parts: ", parts)
    if length != 2:
        settings_dictionary[parts[2]] = int(parts[3])
        update_settings_dictionary()
    return read_settings_file()


file_name = 'settings.json' #JSON workspace
settings_dictionary = create_settings_dictionary() #dictionary based on JSON workspace
arm = servos.arm_servo(settings_dictionary['bot'],
                       settings_dictionary['mid'],
                       settings_dictionary['top'], 15) #initalizing arm servo
table = servos.table_servo(settings_dictionary['left'],
                           settings_dictionary['center'],
                           settings_dictionary['right'], 14) #initalizing table servo

#set secret values
ssid = secrets.ssid
password = secrets.password
station = network.WLAN(network.STA_IF)

#connect to local network
print('network...')
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
station.config(dhcp_hostname='cubotino')
wlan.scan()  
if not wlan.isconnected():
    print('connecting to network...')
    wlan.connect(ssid, password)
    print('connecting...')
    while not wlan.isconnected():
        pass

print('network config:', wlan.ifconfig()[0])
    
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
        print('client connected from: ', addr)
        request = cl.recv(1024)
        request = str(request)
        print("request")
        print(request)
        request = request.split(" ")[1]
        response = ''
        if "settings" in request:
            print("settings")
            response = handle_settings(request)
        else:
            print(request)
            request = request[request.rindex("/") + 1:]
            for i in request:
                print("executing: ", i)
                if i == "T":
                    arm.move_top()
                elif i == "M":
                    arm.move_mid()
                elif i == "B":
                    arm.move_bot()
                elif i == "L":
                    table.move_left()
                elif i == "C":
                    table.move_center()
                elif i == "R":
                    table.move_right()
                else:
                    response = 'Invalid instruction: ' + request
                    print(response)
        # Create and send response
        cl.send('HTTP/1.0 200 OK\r\nContent-type: text/json\r\n\r\n')
        print(response)
        cl.send(response)
        cl.close()
        
    except OSError as e:
        cl.close()
        print('connection closed')