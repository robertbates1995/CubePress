from machine import Pin, PWM
from utime import sleep_ms

 
                
def process_setting(request, arm, table):
    full_set = request.split('setting=')[1]
    print(full_set)
    #segment = 

#def set_servos(arm, table, settings):

class arm_servo:
    # arm servo, connected to Pin 15
    bot = int
    mid = int
    top = int
    servo: PWM()
    
    def move_bot(self):
        self.servo.duty_ns(self.bot)
        sleep_ms(1000)
        
    def move_mid(self):
        self.servo.duty_ns(self.mid)
        sleep_ms(1000)
        
    def move_top(self):
        self.servo.duty_ns(self.top)
        sleep_ms(1000)
        
    def __init__(self, bot, mid, top, pin):
        self.servo = PWM(Pin(pin))
        self.servo.freq(50)
        sleep_ms(50)
        self.bot = bot
        self.mid = mid
        self.top = top
        
class table_servo:
    # arm servo, connected to Pin 16
    left = int
    center = int
    right = int
    servo: PWM()
    
    def move_left(self):
        self.servo.duty_ns(self.left)
        sleep_ms(1000)
        
    def move_center(self):
        self.servo.duty_ns(self.center)
        sleep_ms(1000)
        
    def move_right(self):
        self.servo.duty_ns(self.right)
        sleep_ms(1000)
        
    def __init__(self, left, center, right, pin):
        self.servo = PWM(Pin(pin))
        self.servo.freq(50)
        sleep_ms(50)
        self.left = left
        self.center = center
        self.right = right