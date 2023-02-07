from machine import Pin, PWM
from utime import sleep_ms

 
                
def process_settings(request):
    full_set = request.split('_+_')[1]
    print(full_set)
    #segment = 

#def set_servos(arm, table, settings):

class arm_servo:
    # arm servo, connected to Pin 15
    bot = int
    mid = int
    top = int
    servo: PWM()
    
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
    
    def move(self, move):
        if 'top' in move:
            self.move_top()
    
    def move_bot(self):
        self.servo.duty_ns(self.bot)
        sleep_ms(50)
        
    def move_mid(self):
        self.servo.duty_ns(self.mid)
        sleep_ms(1550)
        
    def move_top(self):
        self.servo.duty_ns(self.top)
        sleep_ms(50)
        
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
    
    def test(self):
        self.move_left()
        print("left = " + str(self.left))
        sleep_ms(1200)
        self.move_right()
        print("right = " + str(self.right))
        sleep_ms(1200)
        self.move_mid()
        print("middle = " + str(self.center))
        sleep_ms(1200)
    
    def move_left(self):
        self.servo.duty_ns(self.left)
        sleep_ms(50)
        
    def move_center(self):
        self.servo.duty_ns(self.center)
        sleep_ms(50)
        
    def move_right(self):
        self.servo.duty_ns(self.right)
        sleep_ms(50)
        
    def __init__(self, left, center, right, pin):
        self.servo = PWM(Pin(pin))
        self.servo.freq(50)
        sleep_ms(50)
        self.left = left
        self.center = center
        self.right = right