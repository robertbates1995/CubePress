from machine import Pin, PWM
from utime import sleep_ms

class arm_servo:
    servo = PWM(Pin(15))
    # arm servo, connected to Pin 15
    bot = int
    mid = int
    top = int
    
    def move_bot(self):
        self.servo.duty_ns(self.bot)
        sleep_ms(50)
        print("bottom")
        
    def move_mid(self):
        self.servo.duty_ns(self.mid)
        sleep_ms(50)
        print("middle")
        
    def move_top(self):
        self.servo.duty_ns(self.top)
        sleep_ms(50)
        print("top")
        
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
    
    def move_left(self):
        self.servo.duty_ns(self.left)
        sleep_ms(50)
        print("left")
        
    def move_mid(self):
        self.servo.duty_ns(self.mid)
        sleep_ms(50)
        print("mid")
        
    def move_right(self):
        self.servo.duty_ns(self.right)
        sleep_ms(50)
        print("right")
        
    
    def __init__(self, a, b, c):
        self.servo.freq(50)
        sleep_ms(50)
        self.left = a
        self.mid = b
        self.right = c
        

def servo_settings(): 
    
    MID_2 = 1500000
    MIN_2 = 455000
    MAX_2 = 3240000
    
    
    #initalize servos
    arm = arm_servo(1560000,1230000,750000)
    #initalize arm servo
    table = table_servo(1750000,750000,500000)
    #initalize table servo
    #TODO: table_servo = table_servo()
    
    #arm.move_top()
    #sleep_ms(1200)
    #arm.move_bot()
    #sleep_ms(1200)
    #arm.move_mid()
    #sleep_ms(1200)

    table.move_left()
    sleep_ms(1200)
    table.move_right()
    sleep_ms(1200)
    table.move_mid()
    

servo_settings()